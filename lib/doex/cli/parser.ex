defmodule Doex.Cli.Parser do
  use FnExpr

  def parse(raw_args, option_defn) do
    {opts, args, _} = OptionParser.parse(raw_args, switches: option_defn |> Map.to_list)
    opts
    |> Enum.map(fn {k,v} ->
         case option_defn[k] do
           :list -> {k, String.split(v, ",")}
           _ -> {k, v}
         end
       end)
    |> Enum.into(%{})
    |> invoke({&1, args})
  end

end