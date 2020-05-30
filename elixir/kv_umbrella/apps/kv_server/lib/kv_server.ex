defmodule KVServer do
  require Logger


  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} =
      Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> server(client) end)
    # Task.start_link(fn -> server(client) end)
    # This makes the child process the “controlling process” of the client socket.
    # If we didn’t do this, the acceptor would bring down all the clients
    # if it crashed because sockets would be tied to the process that accepted them
    # (which is the default behaviour).
    # 让子进程变成控制client的进程, 如果不这样子做
    # acceptor会下架所有的client,如果他crash
    # 因为socket尝试处理它接收过的socket
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp server(socket) do

    # msg =
    #   case read_line(socket) do
    #     {:ok, data} ->
    #       case KVServer.Command.parse(data) do
    #           {:ok, command} -> KVServer.Command.run(command)
    #           {:error, _ } = err -> err
    #       end
    #     {:error, _} = err -> err
    #   end

    msg =
      with {:ok, data} <- read_line(socket),
           {:ok, command} <- KVServer.Command.parse(data),
           do: KVServer.Command.run(command)

    write_line(socket, msg)

    # socket
    # |> read_line()
    # |> write_line(socket)

    server(socket)
  end

  defp read_line(socket) do
    # {:ok, data} = :gen_tcp.recv(socket, 0)
    # data
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Known error; write to the client
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(socket, {:error, :not_found}) do
    # Known error; write to the client
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # 关闭正在执行中的进程, 也就是 服务客户端的 Task
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error) # 异常关闭当前执行的进程
  end
end
