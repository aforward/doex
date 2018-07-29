defmodule Doex.LiveCase do
  defmacro __using__(_) do
    quote do
      setup do
        System.put_env("DOEX_CONFIG", "~/.doex.live")
        Doex.reload()

        on_exit(fn ->
          System.delete_env("DOEX_CONFIG")
          Doex.reload()
        end)

        :ok
      end
    end
  end
end
