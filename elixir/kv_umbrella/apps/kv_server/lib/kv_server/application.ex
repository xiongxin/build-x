defmodule KVServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    port = String.to_integer(System.get_env("PORT", "4040"))

    children = [
      # Starts a worker by calling: KVServer.Worker.start_link(arg)
      # {KVServer.Worker, arg}
      {Task.Supervisor, name: KVServer.TaskSupervisor},
      # {Task, fn -> KVServer.accept(4040) end}
      # Task默认是临时重启,即crash了不重启
      # 下面的方法才能让服务器一直
      Supervisor.child_spec({Task, fn -> KVServer.accept(port) end}, restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KVServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
