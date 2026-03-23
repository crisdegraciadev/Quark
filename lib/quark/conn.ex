defmodule Quark.Conn do
  defstruct method: nil,
            path: nil,
            headers: %{},
            params: %{},
            status: 200,
            resp_headers: %{"content-type" => "text/plain"},
            resp_body: "",
            halted: false
end
