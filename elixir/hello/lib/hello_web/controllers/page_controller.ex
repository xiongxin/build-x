defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def index(conn, _params) do
    IO.puts("#{inspect conn.assigns}")
    conn
    |> put_flash(:info, "aaa")
    |> put_flash(:error, "L error")
    |> render("index.html")
    # |> redirect(to: Routes.hello_path(conn, :index))
  end
end
