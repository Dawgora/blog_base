defmodule HomepageWeb.PageController do
  use HomepageWeb, :controller
  alias Homepage.Posts

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", %{posts: posts})
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: post, page_title: "Dawgora.com - " <> post.title)
  end

  def about(conn, _params) do
    render(conn, "about.html", page_title: "Dawgora: about me")
  end
end
