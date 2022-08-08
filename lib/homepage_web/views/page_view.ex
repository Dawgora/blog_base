defmodule HomepageWeb.PageView do
  use HomepageWeb, :view

  alias Earmark

  def render_md(content) do
    {:ok, html, _} = Earmark.as_html(content, compact_output: true)
    html
end
end
