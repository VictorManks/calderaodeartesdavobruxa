defmodule Calderaodeartedavobruxa.Repo.Migrations.CreateOpinions do
  use Ecto.Migration

  def change do
    create table(:opinions) do
      add :ratin, :integer
      add :opinion_text, :text
      add :artwork_id, references(:artworks, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:opinions, [:user_id])

    create index(:opinions, [:artwork_id])
  end
end
