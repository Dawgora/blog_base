defmodule Homepage.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Homepage.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        context: "some context",
        published: true,
        slug: "some slug",
        title: "some title"
      })
      |> Homepage.Posts.create_post()

    post
  end

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        link: "some link",
        title: "some title"
      })
      |> Homepage.Posts.create_image()

    image
  end
end
