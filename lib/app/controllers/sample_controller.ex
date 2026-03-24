defmodule App.Controllers.SampleController do
  def index(%Quark.Conn{} = conn) do
    %Quark.Conn{conn | resp_body: "Welcome to quark!"}
  end


  def hello(%Quark.Conn{} = conn) do
    %Quark.Conn{conn | resp_body: "Hello from quark!"}
  end
end
