defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    # start_supervised!/1 调用它的start_link/1方法
    # 用于保证在每个请求之前关闭
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end


  test "removes buckets on crash", %{registry: registry} do
    KV.Registry.create(registry, "112")
    {:ok, bucket} = KV.Registry.lookup(registry, "112")
    Agent.stop(bucket, :shutdown) # 非自然停止
    assert KV.Registry.lookup(registry, "112") == :error
  end

end