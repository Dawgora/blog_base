defmodule HomepageWeb.RssController do
  use HomepageWeb, :controller
  alias Homepage.Posts
  alias Atomex.{Feed, Entry}
  alias Earmark

  @author "Dawgora"

  def index(conn, _params) do
    posts = Posts.list_posts()
    feed = build_feed(posts, conn)

    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, feed)
  end

  def build_feed(posts, conn) do
    Feed.new(Routes.page_path(conn, :index), DateTime.utc_now, "dawgora.com RSS feed")
    |> Feed.author(@author)
    |> Feed.link(Routes.rss_path(conn, :index), rel: "self")
    |> Feed.entries(Enum.map(posts, &get_entry(conn, &1)))
    |> Feed.build()
    |> Atomex.generate_document()
  end

  defp get_entry(conn, %{title: title, body: body, inserted_at: inserted_at} = post) do
    Entry.new(Routes.page_path(conn, :show, post), DateTime.from_naive!(inserted_at, "Etc/UTC"), title)
    |> Entry.link(Routes.page_path(conn, :show, post))
    |> Entry.author(@author)
    |> Entry.content(render_md(body), type: "text")
    |> Entry.build()
  end

  def render_md(content) do
    {:ok, html, _} = Earmark.as_html(content, compact_output: true)
    html
end
end
