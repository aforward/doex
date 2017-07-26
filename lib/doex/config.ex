defmodule Doex.Config do

  use FnExpr

  @default_filename "~/.doex"

  def filename do
    case Application.get_env(:doex, :config) do
      nil -> case System.get_env("DOEX_CONFIG") do
               nil -> lookup_filename()
               f -> f
             end
             |> Path.expand
      _ -> :config
    end
  end

  def init(), do: filename() |> init
  def init(:config), do: :config
  def init(filename) do
    :ok = filename |> Path.dirname |> File.mkdir_p!

    unless File.exists?(filename) do
      filename |> reinit
    end
    filename
  end

  def reinit(), do: filename() |> reinit
  def reinit(:config), do: :config
  def reinit(filename) do
    :ok = write(filename, default_config())
    filename
  end

  def get(key), do: filename() |> get(key)
  def get(:config, key), do: read() |> Map.get(key)
  def get(filename, key) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.get(key)
  end

  def put(key, value), do: filename() |> put(key, value)
  def put(:config, _key, _value), do: {:error, :readonly}
  def put(filename, key, value) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.merge(%{key => value})
    |> invoke(fn map -> write(filename, map) end)
  end

  def remove(key), do: filename() |> remove(key)
  def remove(:config, _key), do: {:error, :readonly}
  def remove(filename, key) do
    filename
    |> Path.expand
    |> init
    |> read
    |> Map.delete(key)
    |> invoke(fn map -> write(filename, map) end)
  end

  def read(), do: filename() |> read
  def read(:config), do: Application.get_env(:doex, :config)
  def read(filename) do
    filename
    |> Path.expand
    |> File.read
    |> invoke(fn result ->
         case result do
           {:ok, content} -> :erlang.binary_to_term(content)
           {:error, _} -> default_config()
         end
       end)
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
    |> Path.expand
    |> File.write!(:erlang.term_to_binary(map))
  end

  defp default_config do
    %{
        token: "FILL_ME_IN",
        ssh_keys: [],
        url: "https://api.digitalocean.com/v2"
     }
  end

end
