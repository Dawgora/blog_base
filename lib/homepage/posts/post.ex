defmodule Homepage.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Phoenix.Param, key: :slug}

  schema "posts" do
    field :body, :string
    field :context, :string
    field :published, :boolean, default: false
    field :slug, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :published, :title, :slug, :context])
    |> validate_required([:body, :published, :title, :slug, :context])
  end
end
