defmodule Quark.Parser do
  alias Quark.Conn

  def parse(client_socket) do
    {method, path} = read_request_line(client_socket)
    headers = read_headers(client_socket)

    %Conn{
      method: to_string(method),
      path: path,
      headers: headers
    }
  end

  defp read_request_line(socket) do
    {:ok, {:http_request, method, {:abs_path, path}, _version}} = :gen_tcp.recv(socket, 0)
    {method, path}
  end

  defp read_headers(socket, acc \\ %{}) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, :http_eoh} ->
        acc

      {:ok, {:http_header, _, name, _, value}} ->
        key = name |> to_string() |> String.downcase()
        read_headers(socket, Map.put(acc, key, value))
    end
  end
end
