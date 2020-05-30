# GETTING START

## 11 Proccesses

### Links

使用`spawn/1`,子进程发生错误时,不会影响到父进程.父进程接收到错误信息之后继续允许.这是因为进程之间都是隔离的.

使用`spawn_link/1`时,进程之间被连接起来,如果子进程报错,我们可以看到父进程会接收到`EXIT`信息.父进程会自动重启.

Links允许进程之间建立一种发生错误时的关系.经常会使用监视器连接进程,监视器会检测到一个进程死亡,并且自动开启一个新进程替换



## 14 Module Attributes

模块的主要作用：

1. 注解模块，经常被用户或VM提供信息
2. 常量
3. 临时模块存储，在编译时使用

最常用的模块属性:

- `@moduledoc`
- `@doc`
- `@behaviour` OTP定义或者用户定义行为
- `@before_compile`提供钩子在模块编译之前指向，可以编译之前注入函数进来



### 常量

```elixir
defmodule MyApp.Notification do
  @service Application.get_env(:my_app, :email_service)
  @message Application.get_env(:my_app, :welcome_email)
  def welcome(email), do: @service.send_welcome_message(email, @message)
end
```



### 临时存储

```elixir
defmodule MyPlug do
  use Plug.Builder

  plug :set_header
  plug :send_ok

  def set_header(conn, _opts) do
    put_resp_header(conn, "x-header", "set")
  end

  def send_ok(conn, _opts) do
    send_resp(conn, 200, "ok")
  end
end

IO.puts "Running MyPlug with Cowboy on http://localhost:4000"
Plug.Adapters.Cowboy.http MyPlug, []
```



上面我们使用`plug/1`宏连接函数，当有一个web request进来时调用。在模块内部，每次调用`plug/1`，Plug库存储指定的参数到一个`@plugs`属性。在模块编译之前，Plug运行一个回调，定义函数(`call/2`)捕获HTTP request.这个函数将会按顺序运行内部的`@plugs`.



## 16 Protocols

### Example

`length`意味着信息需要计算, `size`意味着提前知道大小。

```elixir
defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end
```

## Typespaces and behaviours

### Types and specs

Elixir使用`typespecs`标记:

- 声明函数参数类型
- 声明自定义类型

#### Function specifications

```elixir
round(number()) :: integer()
```

# Mix and OTP

## Introduction to Mix

- OTP(Open telecom Platform)是Eralng自带的一些库.Erlang开发者使用OTP构建,鲁棒性,容错的应用.
- Mix 是Elixir的build tool
- ExUnit

## Agent

- Agent - 简单的封装state
- GenServer - "Generic servers"(进程) 封装状态,提供同步和异步调用,支持代码热重启等等
- Task - 异步计算单元,允许开启进程,并且保证在之后的时间内获取返回结果

### Agents

## GenServer

这里我们总结一下GenServer的各个回调方法:

- `handle_call/3` 必须时通过请求. 这是一个非常有用的背压机制(backpressure mechainsim)一个默认呢的选择等待服务器回复.
- `handle_cast/2` 是异步请求,不用关心回复. cast甚至不关注服务端是否接收到消息,例如:`create/2`函数我们定义的就时这样
- `handle_info/2`一般用于处理其他服务端发送过来的消息,不包括`GenServer.call/2`或者`GenServer.cast/2`,但是包含使用`send/2`发送的消息.

## Supervisor

```elixir
defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      KV.Registry
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```



监视器的strategy决定当前子进程crash时,如果处理,`:one_for_one`仅重启一个crash的子进程.



当监视器启动,即调用`init`方法,它将编译children列表,调用每个模块的`child_spec/1`方法.`child_spec`方法描述了如何启动进程,进程是一个工作进程还是监视器,进程是temporay, transient, permanent等等. `child_spec/1`在使用`use Agent`, `use GenServer`, `use Supervisor`时会自动定义.

```bash
iex(1)> KV.Registry.child_spec([])
%{id: KV.Registry, start: {KV.Registry, :start_link, [[]]}}
```

在supervisor获取所有子进程的spec之后,它会根据定义的列表顺序一个接一个的开启子进程, 使用信息在`:start`关键词中. 如上面的示例,它将调用`KV.Registry.start_link([])`.

```bas
iex(1)> {:ok, sup} = KV.Supervisor.start_link([])
{:ok, #PID<0.148.0>}
iex(2)> Supervisor.which_children(sup)
[{KV.Registry, #PID<0.150.0>, :worker, [KV.Registry]}]
```

在开启监视器之后,子进程是自动创建的.



### 进程命名



## ETS

```bash
iex> table = :ets.new(:buckets_registry, [:set, :protected])
#Reference<0.1885502827.460455937.234656>
iex> :ets.insert(table, {"foo", self()})
true
iex> :ets.lookup(table, "foo")
[{"foo", #PID<0.41.0>}]
```

参数类型:

- `:set` 集合类型不可重复
- `:protected` 所有进程可读取
- `:public` 所有进程可读写
- `:private` 仅当前进程可读写



ets可以命名:

```basg
iex> :ets.new(:buckets_registry, [:named_table])
:buckets_registry
iex> :ets.insert(:buckets_registry, {"foo", self()})
true
iex> :ets.lookup(:buckets_registry, "foo")
[{"foo", #PID<0.41.0>}]
```

## Echo Server

一个TCP服务器,一般处理的流程:

1. 监听端口直到端口可用,获取进来的socket
2. 等待客户端连接端口并获取它
3. 读取请求内容,返回响应内容



```elixir

defmodule KVServer do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
```





# META-PROGRAMMING IN ELIXIR

## Quote And UnQuote

### Quoting

```bash
iex> quote do: sum(1, 2, 3)
{:sum, [], [1, 2, 3]}

iex> quote do: 1 + 2
{:+, [context: Elixir, import: Kernel], [1, 2]}

iex> quote do: %{1 => 2}
{:%{}, [], [{1, 2}]}

iex> quote do: x
{:x, [], Elixir}

iex> quote do: sum(1, 2 + 3, 4)
{:sum, [], [1, {:+, [context: Elixir, import: Kernel], [2, 3]}, 4]}

iex> Macro.to_string(quote do: sum(1, 2 + 3, 4))
"sum(1, 2 + 3, 4)"
```

一般,上面的元组时由这样子的形式组成:

```elixir

{ atom | tuple, list, list | atom }
```

* 第一个元素时院子或者其他的元组
* 第二个元素包含元素局,像数值和上下文
* 第三个元素是函数参数列表或者原子

在元组定义之上,Elxiir有5种字面量,当使用quote时,返回自身,而不是元组

```bash
:sum         #=> Atoms
1.0          #=> Numbers
[1, 2]       #=> Lists
"strings"    #=> Strings
{key, value} #=> Tuples with two elements
```

大部分Elixir代码直接翻译底层代码到quoted表达式

### Unquoting

Quote是获取一些实际的代码转到内部的代表.有时候我们需要在quote中注入一些其他的代码片段.

```base
iex> number = 13
iex> Macro.to_string(quote do: 11 + number)
"11 + number"
```

unquote可以用于注入代码到quoted代表中:

```base
iex> number = 13
iex> Macro.to_string(quote do: 11 + unquote(number))
"11 + 13"

iex> fun = :hello
iex> Macro.to_string(quote do: unquote(fun)(:world))
"hello(:world)"

iex> inner = [3, 4, 5]
iex> Macro.to_string(quote do: [1, 2, unquote(inner), 6])
"[1, 2, [3, 4, 5], 6]"

iex> inner = [3, 4, 5]
iex> Macro.to_string(quote do: [1, 2, unquote_splicing(inner), 6])
"[1, 2, 3, 4, 5, 6]"
```

Unquoting在配合宏时是非常有用的.写macros,开发者接收代码片段,注入一些其他的代码进来,可以用于传输代码,写代码,然后生成对应的代码

































