defmodule HomepageWeb.Plugs.RedirectPlug do
  alias Phoenix.Controller
  alias Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{host: "www." <> host} = conn, _default) do
    url =
      Controller.current_url(conn)
      |> URI.parse()
      |> Map.put(:host, host)
      |> URI.to_string()

    conn
    |> Conn.put_resp_header("location", url)
    |> Conn.resp(:permanent_redirect, "permanent redirect")
    |> Conn.halt()
  end

  def call(conn, _default), do: conn
end
