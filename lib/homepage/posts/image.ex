defmodule Homepage.Posts.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :link, :string
    field :title, :string
    field :image, :any, virtual: true

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:link, :title, :image])
    |> validate_required([:title, :image])
    |> unique_constraint([:title])
  end

  @doc false
  def update_changeset(image, attrs) do
    image
    |> cast(attrs, [:link, :title])
    |> validate_required([:title])
    |> unique_constraint([:title])
  end
end
