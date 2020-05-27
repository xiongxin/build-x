# GETTING START

## 11 Proccesses

### Links

使用`spawn/1`,子进程发生错误时,不会影响到父进程.父进程接收到错误信息之后继续允许.这是因为进程之间都是隔离的.

使用`spawn_link/1`时,进程之间被连接起来,如果子进程报错,我们可以看到父进程会接收到`EXIT`信息.父进程会自动重启.

Links允许进程之间建立一种发生错误时的关系.经常会使用监视器连接进程,监视器会检测到一个进程死亡,并且自动开启一个新进程替换死亡的进程.

### Tasks

Tasks是对`spawn/1`函数的封装,提供更好的错误报告和自省功能:

```shell
iex(1)> Task.start fn -> raise "oops" end
{:ok, #PID<0.55.0>}

15:22:33.046 [error] Task #PID<0.55.0> started from #PID<0.53.0> terminating
** (RuntimeError) oops
    (stdlib) erl_eval.erl:668: :erl_eval.do_apply/6
    (elixir) lib/task/supervised.ex:85: Task.Supervised.do_apply/2
    (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
Function: #Function<20.99386804/0 in :erl_eval.expr/5>
    Args: []
```



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

GenServer必须定义的两个回调方法：

- `calls` 同步调用,server必须返回响应给client,当server计算响应结果时,client必须等待.
- `casts`时异步调用,server不会响应client.





































