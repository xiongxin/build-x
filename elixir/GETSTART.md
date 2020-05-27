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







































