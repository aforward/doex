defmodule Doex.Config do

  use FnExpr

  @default_filename "~/.doex"

  def filename do
    case System.get_env("DOEX_CONFIG") do
      nil -> lookup_filename()
      f -> f
    end
    |> Path.expand
  end

  def init(), do: filename() |> init
  def init(filename) do
    :ok = filename |> Path.dirname |> File.mkdir_p!
    unless File.exists?(filename) do
      filename |> reinit
    end
    filename
  end

  def reinit(), do: filename() |> reinit
  def reinit(filename) do
    :ok = write(filename, default_config())
    filename
  end

  def get(key), do: filename() |> get(key)
  def get(filename, key) do
    filename
    |> init
    |> read
    |> Map.get(key)
  end

  def put(key, value), do: filename() |> put(key, value)
  def put(filename, key, value) do
    filename
    |> init
    |> read
    |> Map.merge(%{key => value})
    |> invoke(fn map -> write(filename, map) end)
  end

  def remove(key), do: filename() |> remove(key)
  def remove(filename, key) do
    filename
    |> init
    |> read
    |> Map.delete(key)
    |> invoke(fn map -> write(filename, map) end)
  end

  def read(), do: filename() |> read
  def read(filename) do
    filename
    |> File.read!
    |> :erlang.binary_to_term
  end

  defp lookup_filename do
    [
      ".doex",
    ]
    |> Enum.filter(&File.exists?/1)
    |> Enum.fetch(0)
    |> case do
      :error -> @default_filename
      {:ok, f} -> f
    end
  end

  defp write(filename, map) do
    filename
    |> File.write!(:erlang.term_to_binary(map))
  end

  defp default_config do
    %{
        token: "FILL_ME_IN",
        ssh_keys: [],
     }
  end

end
