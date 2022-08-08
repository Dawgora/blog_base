defmodule Homepage.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :link, :string
      add :title, :string

      timestamps()
    end
  end
end
