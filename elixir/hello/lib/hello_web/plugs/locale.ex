defmodule HelloWeb.Plugs.Locale do
  import Plug.Conn
  @locales ["en", "fr", "de"]

  def init(default) do
    IO.puts """
    init default: #{inspect(default)}
    """
    default
  end

  def call(%Plug.Conn{ params: %{"locale" => loc} } = conn, default) when loc in @locales do
    IO.puts """
    call1 default: #{inspect(default)}
    call1 assigns: #{inspect(conn.assigns)}
    """
    assign(conn, :locale, loc)
  end

  def call(conn, default) do
    IO.puts """
    call2 default: #{inspect(default)}
    call2 default: #{inspect(conn.assigns)}
    """
    assign(conn, :locale, default)
  end
end
