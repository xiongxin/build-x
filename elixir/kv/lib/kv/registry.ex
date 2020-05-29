defmodule KV.Registry do
  use GenServer

  ## Missing Client API - will add this later

  @doc """
  Start the registry with the given options.
  `:name` is always required.
  """
  def start_link(opts) do
    # 返回 {:ok, pid}, pid为当前模块运行进程
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    case :ets.lookup(server, name) do
      [{^name, pid}] ->
        IO.puts("创建name #{name} #{inspect server}")
        {:ok, pid}
      [] ->
        IO.puts("创建name #{name} #{inspect server}")
        :error
    end
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  ## Defining GenServer Callbacks

  @impl true
  def init(table) do
    # GenServer.start_link(MODULE, :ok),
    # 通过参数匹配找到当前方法初始化GenServer状态
    # 同步返回值 {:ok, state}

    # 3. 将names map 存放到 ETS 表中
    names = :ets.new(table, [ :named_table, read_concurrency: true ])
    refs = %{}
    IO.puts("创建name #{inspect names}")
    {:ok, {names, refs}} # 当前注册保存一个map对象
  end

  # 4. 使用前面的lookup方法从ets表中替换下面的方法

  # @impl true
  # def handle_call({:lookup, name}, _from, state) do
  #   {names, _} = state
  #   # 同步返回值 {:reply, reply, new_state}
  #   {:reply, Map.fetch(names, name), state}
  # end

  @impl true
  def handle_call({:create, name},_from, {names, refs} ) do
    # 异步返回值 {:noreply, new_state}

    case lookup(names, name) do
       {:ok, pid} ->
          {:reply, pid, {names, refs}}
       :error ->
          {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
          ref = Process.monitor(pid)
          refs = Map.put(refs, ref, name)
          :ets.insert(names, {name, pid})
          {:reply, pid, {names, refs}}
    end
    # if Map.has_key?(names, name) do
    #   {:noreply, {names, refs}}
    # else
    #   # 改成下面动态监视器创建进程 {:ok, bucket} = KV.Bucket.start_link([]) # 开启 Agent 对象
    #   {:ok, bucket } = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
    #   names = Map.put(names, name, bucket)
    #   ref = Process.monitor(bucket)
    #   refs  = Map.put(refs, ref, name)
    #   {:noreply, { names, refs }}
    # end
  end

  # 使用动态监视器时,也会收到下线的消息
  # 当进程异常关闭时, 监听当前进程,会收到正常下线消息
  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # 异步返回值 {:noreply, new_state}
    { name, refs } = Map.pop(refs, ref)
    # names = Map.delete(names, name)
    :ets.delete(names, name)
    {:noreply, { names, refs } }
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
