defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  plug :fetch_message

  def index(conn, _params) do
    IO.puts("ASSING #{inspect conn.assigns}")
    render(conn, "index.html")
  end

  def show(conn, %{"messenger" => messenger}) do
    render(conn, "show.html", messenger: messenger)
  end

  defp fetch_message(conn, _) do
    assign(conn, :message, "message A")
  end

end
