defmodule Quark.Router do
  defmacro __using__(_opts) do
    quote do
      import Quark.Router

      def call(conn) do
        dispatch(conn)
      end
    end
  end

  defmacro get(path, to: controller, action: action) do
    quote do
      defp dispatch(%Quark.Conn{method: "GET", path: unquote(path)} = conn) do
        apply(unquote(controller), unquote(action), [conn])
      end
    end
  end

  defmacro fallback_routes() do
    quote do
      defp dispatch(%Quark.Conn{} = conn), do: %Quark.Conn{conn | status: 404}
    end
  end
end
