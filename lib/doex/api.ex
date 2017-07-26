defmodule Doex.Api do

  use FnExpr

  @moduledoc"""
  Make generic HTTP calls a web service.  Please
  update (or remove) the tests to a sample service
  in the examples below.
  """

  @doc"""
  Retrieve data from the API using either :get or :post
  """
  def call(:get, %{source: source, headers: headers}), do: get(source, headers)
  def call(:get, %{source: source}), do: get(source)
  def call(:post, %{source: source, body: body, headers: headers}), do: post(source, body, headers)
  def call(:post, %{source: source, body: body}), do: post(source, body)
  def call(:post, %{source: source}), do: post(source)

  @doc"""
  Make an API call using GET.  Optionally provide any required headers
  """
  def get(source), do: get(source, nil)
  def get(source, headers) do
    source
    |> resolve_url
    |> HTTPoison.get(encode_headers(headers))
    |> parse
  end

  @doc"""
  Make an API call using POST.  Optionally provide any required data and headers
  """
  def post(source), do: post(source, %{}, %{})
  def post(source, body), do: post(source, body, %{})
  def post(source, body, headers) do
    source
    |> resolve_url
    |> HTTPoison.post(
         encode_body(headers[:body_type] || headers[:content_type], body),
         encode_headers(headers)
       )
    |> parse
  end

  @doc"""
  Encode the provided hash map for the URL.

  ## Examples

      iex> Doex.Api.encode_body(%{a: "one", b: "two"})
      "{\\"b\\":\\"two\\",\\"a\\":\\"one\\"}"

      iex> Doex.Api.encode_body(%{a: "o ne"})
      "{\\"a\\":\\"o ne\\"}"

      iex> Doex.Api.encode_body(nil, %{a: "o ne"})
      "{\\"a\\":\\"o ne\\"}"

      iex> Doex.Api.encode_body("application/x-www-form-urlencoded", %{a: "o ne"})
      "a=o+ne"

      iex> Doex.Api.encode_body("application/json", %{a: "b"})
      "{\\"a\\":\\"b\\"}"

  """
  def encode_body(map), do: encode_body(nil, map)
  def encode_body(nil, map), do: encode_body("application/json", map)
  def encode_body("application/x-www-form-urlencoded", map), do: URI.encode_query(map)
  def encode_body("application/json", map), do: Poison.encode!(map)
  def encode_body(_, map), do: encode_body(nil, map)

  @doc"""
  Build the headers for your API

  ## Examples

      iex> Doex.Api.encode_headers(%{content_type: "application/json", bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}, {"Content-Type", "application/json"}]

      iex> Doex.Api.encode_headers(%{bearer: "abc123"})
      [{"Authorization", "Bearer abc123"}]

      iex> Doex.Api.encode_headers(%{})
      [{"Authorization", "Bearer FILL_ME_IN"}]

      iex> Doex.Api.encode_headers()
      [{"Authorization", "Bearer FILL_ME_IN"}]

      iex> Doex.Api.encode_headers(nil)
      [{"Authorization", "Bearer FILL_ME_IN"}]

  """
  def encode_headers(), do: encode_headers(%{})
  def encode_headers(nil), do: encode_headers(%{})
  def encode_headers(data) do
    data
    |> reject_nil
    |> invoke(fn clean_data -> Map.merge(default_headers(), clean_data) end)
    |> Enum.map(&header/1)
    |> Enum.reject(&is_nil/1)
  end
  defp header({:bearer, bearer}), do: {"Authorization", "Bearer #{bearer}"}
  defp header({:content_type, content_type}), do: {"Content-Type", content_type}
  defp header({:body_type, _}), do: nil

  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok, body |> Poison.decode!}
  end
  defp parse({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    message = body |> String.replace("\\\"", "\"") |> Poison.decode!
    {:error, "Expected a 200, received #{code}", message}
  end
  defp parse({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason, nil}
  end

  defp reject_nil(map) do
    map
    |> Enum.reject(fn{_k,v} -> v == nil end)
    |> Enum.into(%{})
  end

  @doc"""
  Provided the relative path of the Digital Ocean API, resolve the
  full URL

  ## Examples

      iex> Doex.Api.resolve_url("/accounts")
      "https://api.digitalocean.com/v2/accounts"

  """
  def resolve_url(source), do: "#{Doex.config[:url]}#{source}"

  defp default_headers, do: %{bearer: Doex.config[:token]}

end