defmodule Doex.Api do

  use FnExpr

  @moduledoc"""
  Make almost direct calls to the Digital Ocean API.

  Assuming your configs are properly setup, then you only need to provide
  the endpoint after the `/v2` in the DO API, so to access your account
  you would run

      Doex.Api.get("/account")

  OR, you encode the method, and make the same call like

      Doex.Api.call(:get, %{source: "/account"})

  If your configurations are message up (or other errors occur), it will look
  similar to

      {:error,
       "Expected a 200, received 401",
       %{"id" => "unauthorized", "message" => "Unable to authenticate you."}}

  If things are working as expected, a success message looks like

      {:ok,
       %{"account" => %{"droplet_limit" => 99, "email" => "me@example.com",
           "email_verified" => true, "floating_ip_limit" => 5, "status" => "active",
           "status_message" => "",
           "uuid" => "abcdefghabcdefghabcdefghabcdefghabcdefgh"}}}

  To send a POST command, for example creating a new droplet, you can run

      Doex.Api.post(
         "/droplets",
         %{name: "dplet001",
           region: "tor1",
           size: "512mb",
           image: "ubuntu-14-04-x64",
           ssh_keys: [12345],
           backups: false,
           ipv6: true,
           user_data: nil,
           private_networking: nil,
           volumes: nil,
           tags: ["dplet001"]})

  OR, you encode the method, and make the same call like

      Doex.Api.call(
       :post,
       %{source: "/droplets",
         body: %{name: "dplet001",
                 region: "tor1",
                 size: "512mb",
                 image: "ubuntu-14-04-x64",
                 ssh_keys: [12345],
                 backups: false,
                 ipv6: true,
                 user_data: nil,
                 private_networking: nil,
                 volumes: nil,
                 tags: ["dplet001"]}})

  You could also provide additional headers within the call, but the defaults of

        %{bearer: <your configured token>,
          content_type: "application/json"}

  Should be sufficient.  But if you needed to make the calls directly without
  any loaded config, then you could.  For example,

        Doex.Api.get(
         "/account",
         %{bearer: "ABC123",
           content_type: "application/json"})

  OR,

        Doex.Api.call(
         :get,
         %{source: "/account",
           header: %{bearer: "ABC123",
                     content_type: "application/json"}})

  A similar approach can be used for sending the headers via a POST call.
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
      [{"Authorization", "Bearer abc123"}, {"Content-Type", "application/json"}]

      iex> Doex.Api.encode_headers(%{})
      [{"Authorization", "Bearer FILL_ME_IN"}, {"Content-Type", "application/json"}]

      iex> Doex.Api.encode_headers()
      [{"Authorization", "Bearer FILL_ME_IN"}, {"Content-Type", "application/json"}]

      iex> Doex.Api.encode_headers(nil)
      [{"Authorization", "Bearer FILL_ME_IN"}, {"Content-Type", "application/json"}]

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

  defp parse({:ok, %HTTPoison.Response{status_code: 200} = resp}), do: parse(resp)
  defp parse({:ok, %HTTPoison.Response{status_code: 202} = resp}), do: parse(resp)
  defp parse({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    message = body |> String.replace("\\\"", "\"") |> Poison.decode!
    {:error, "Expected a 200, received #{code}", message}
  end
  defp parse({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason, nil}
  end
  defp parse(%HTTPoison.Response{body: body}), do: {:ok, body |> Poison.decode!}


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

  defp default_headers do
    %{bearer: Doex.config[:token],
      content_type: "application/json"}
  end

end