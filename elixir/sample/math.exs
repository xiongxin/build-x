defmodule Math do
    def zero?(0) do
        true
    end

    def zero?(x) when is_integer(x) do
        false
    end

    def sum(list) do
        sum(list, 0)
    end

    // 这里仅匹配列表中有元素的情况
    def sum([ head | tail ], accumulator) do
        sum(tail, head + accumulator)
    end
    // 匹配空列表的情况
    def sum([], accumulator) do
        accumulator
    end
end

defmodule Concat do
    def join(a, b \\ nil, sep \\ " ")

    def join(a, b, _sep) when is_nil(b) do
        a
    end

    def join(a, b, sep) do
        a <> sep <> b
    end
end

defmodule Recursion do
    def print_multiple_times(msg, n) when n <= 1 do
        IO.puts(msg)
    end

    def print_multiple_times(msg, n) do
        IO.puts msg
        print_multiple_times(msg, n - 1)
    end
end


IO.puts(Concat.join("Hello"))
Recursion.print_multiple_times("msg", 10)
IO.puts(Math.sum([1,2,3,4,5]))
