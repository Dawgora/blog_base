defmodule Homepage.PostsTest do
  use Homepage.DataCase

  alias Homepage.Posts

  describe "posts" do
    alias Homepage.Posts.Post

    import Homepage.PostsFixtures

    @invalid_attrs %{body: nil, context: nil, published: nil, slug: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", context: "some context", published: true, slug: "some slug", title: "some title"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.context == "some context"
      assert post.published == true
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", context: "some updated context", published: false, slug: "some updated slug", title: "some updated title"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.context == "some updated context"
      assert post.published == false
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "images" do
    alias Homepage.Posts.Image

    import Homepage.PostsFixtures

    @invalid_attrs %{link: nil, title: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Posts.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Posts.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{link: "some link", title: "some title"}

      assert {:ok, %Image{} = image} = Posts.create_image(valid_attrs)
      assert image.link == "some link"
      assert image.title == "some title"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{link: "some updated link", title: "some updated title"}

      assert {:ok, %Image{} = image} = Posts.update_image(image, update_attrs)
      assert image.link == "some updated link"
      assert image.title == "some updated title"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_image(image, @invalid_attrs)
      assert image == Posts.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Posts.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Posts.change_image(image)
    end
  end
end
