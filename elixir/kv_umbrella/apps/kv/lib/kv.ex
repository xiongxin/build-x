defmodule KV do
  use Application

  @moduledoc """
  Documentation for `KV`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KV.hello()
      :world

  """
  def hello do
    :world
  end

  @impl true
  def start(_type, _args) do
    # 尽管没有直接使用superivisor名
    # 它可以在debug时使用
    KV.Supervisor.start_link(name: KV.Supervisor)
  end
end
