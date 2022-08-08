defmodule HomepageWeb.PostLive.Show do
  use HomepageWeb, :live_view

  alias Homepage.Posts
  alias Earmark

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Posts.get_post!(id))}
  end

  def render_md(content) do
    {:ok, html, _} = Earmark.as_html(content, compact_output: true)
    html
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
