defmodule KV.Registry do
  use GenServer

  ## Missing Client API - will add this later

  @doc """
  Start the registry.
  """
  def start_link(opts) do
    # 返回 {:ok, pid}, pid为当前模块运行进程
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(:ok) do
    # GenServer.start_link(MODULE, :ok),
    # 通过参数匹配找到当前方法初始化GenServer状态
    # 同步返回值 {:ok, state}

    name = %{}
    refs = %{}

    {:ok, {name, refs}} # 当前注册保存一个map对象
  end

  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    # 同步返回值 {:reply, reply, new_state}
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs} ) do
    # 异步返回值 {:noreply, new_state}
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      # 改成下面动态监视器创建进程 {:ok, bucket} = KV.Bucket.start_link([]) # 开启 Agent 对象
      {:ok, bucket } = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      names = Map.put(names, name, bucket)
      ref = Process.monitor(bucket)
      refs  = Map.put(refs, ref, name)
      {:noreply, { names, refs }}
    end
  end

  # 使用动态监视器时,也会收到下线的消息
  # 当进程异常关闭时, 监听当前进程,会收到正常下线消息
  @impl true
  def handle_info({:DOWN, ref, :process, pid, _reason}, {names, refs}) do
    # 异步返回值 {:noreply, new_state}
    { name, refs } = Map.pop(refs, ref)
    IO.puts("回调的名称 #{name}")
    names = Map.delete(names, name)

    {:noreply, { names, refs } }
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
