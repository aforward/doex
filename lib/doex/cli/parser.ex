defmodule Doex.Cli.Parser do
  use FnExpr

  def parse(raw_args), do: parse(raw_args, nil)
  def parse(raw_args, nil), do: _parse(raw_args, %{}, switches: [], allow_nonexistent_atoms: true)

  def parse(raw_args, switches),
    do: _parse(raw_args, switches, switches: switches |> Map.to_list())

  defp to_option_parser_opts(parse_opts) do
    Enum.map(parse_opts, fn
      {:switches, switches} ->
        {:switches,
         Enum.map(switches, fn
           {k, :list} -> {k, :string}
           asis -> asis
         end)}

      asis ->
        asis
    end)
  end

  defp _parse(raw_args, switches, parse_opts) do
    {opts, args, _} = OptionParser.parse(raw_args, to_option_parser_opts(parse_opts))

    config = Doex.Config.read()

    switches
    |> Enum.map(fn {name, type} -> {name, defaulted(config, name, type)} end)
    |> Enum.into(%{})
    |> Map.merge(opts |> Enum.into(%{}))
    |> Enum.map(fn {k, v} ->
      case switches[k] do
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
  defp defaulted(:integer), do: 0

  defp to_list(nil), do: []
  defp to_list(l) when is_list(l), do: l
  defp to_list(v) when is_binary(v), do: String.split(v, ",")
end
