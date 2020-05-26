defprotocol Utility do
  @spec type(t) :: String.t()
  def type(value)
end

defimpl Utility, for: BitString do
  def type(_value) do: "string"
end

defimpl Utility, for: Integer do
  def type(_value) do: "Integer"
end
