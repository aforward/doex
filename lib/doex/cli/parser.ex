defmodule Doex.Cli.Parser do
  use FnExpr

  def parse(raw_args, option_defn \\ %{}) do
    {opts, args, _} = OptionParser.parse(raw_args, switches: option_defn |> Map.to_list)
    config = Doex.Config.read

    option_defn
    |> Enum.map(fn {name, type} -> {name, defaulted(config, name, type)} end)
    |> Enum.into(%{})
    |> Map.merge(opts |> Enum.into(%{}))
    |> Enum.map(fn {k,v} ->
         case option_defn[k] do
           :list -> {k, to_list(v)}
           _ -> {k, v}
         end
       end)
    |> Enum.into(%{})
    |> invoke({&1, args})
  end

  defp defaulted(config, name, type), do: config[name] || defaulted(type)
  defp defaulted(:boolean), do: false
  defp defaulted(:string), do: nil
  defp defaulted(:list), do: []

  defp to_list(nil), do: []
  defp to_list(l) when is_list(l), do: l
  defp to_list(v) when is_binary(v), do: String.split(v, ",")

end