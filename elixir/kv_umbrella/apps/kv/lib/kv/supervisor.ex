defmodule KV.Supervisor do
  use Supervisor
  # :one_for_one 一个子进程非正常停止时,可以重启一个子进程
  # 一个子进程挂了,可以重启所有子进程
  # 响应系统关闭而关闭子进程

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      # 添加动态监视器
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}
    ]

    # 调用指定模块的 child_spec/1 方法
    Supervisor.init(children, strategy: :one_for_one)
  end
end
