defmodule Quark.Server do
  require Logger

  def start(port \\ 4000) do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [
        :binary,
        packet: :http,
        active: false,
        reuseaddr: true
      ])

    Logger.info("Ignite is heating up on http://localhost:#{port}")

    loop_acceptor(listen_socket)
  end

  defp loop_acceptor(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    spawn(fn -> serve(client_socket) end)
    loop_acceptor(listen_socket)
  end

  defp serve(client_socket) do
    {method, path} = read_request_line(client_socket)
    Logger.info("Received: #{inspect({method, path})}")

    body = "Hello, Ignite!"
    response = build_response(200, body)
    :gen_tcp.send(client_socket, response)
    :gen_tcp.close(client_socket)
  end

  defp read_request_line(socket) do
    {:ok, {:http_request, method, {:abs_path, path}, _version}} = :gen_tcp.recv(socket, 0)
    {method, path}
  end

  defp build_response(status, body) do
    "HTTP/1.1 #{status} OK\r\n" <>
      "Content-Type: text/plain\r\n" <>
      "Content-Length: #{byte_size(body)}\r\n" <>
      "Connection: close\r\n" <>
      "\r\n" <>
      body
  end
end
