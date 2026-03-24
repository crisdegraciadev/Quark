defmodule Quark.Server do
  alias Quark.Parser

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
    conn = Parser.parse(client_socket)
    conn = App.Router.call(conn)

    response = build_response(conn.status, conn.resp_body)
    :gen_tcp.send(client_socket, response)
    :gen_tcp.close(client_socket)
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
