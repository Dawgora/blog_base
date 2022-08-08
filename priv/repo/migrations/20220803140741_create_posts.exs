defmodule Homepage.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text
      add :published, :boolean, default: false, null: false
      add :title, :string
      add :slug, :string
      add :context, :text

      timestamps()
    end
  end
end
