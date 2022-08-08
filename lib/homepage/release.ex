defmodule Homepage.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :homepage

  @start_apps [
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def migrate do
    start_services()
    run_migrations()
    stop_services()
  end

  defp start_services do
    IO.puts("Starting dependencies")

    Enum.each(@start_apps, &Application.ensure_all_started/1)
  end

  defp stop_services do
    IO.puts("Success")
    :init.stop()
  end

  defp run_migrations do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end
