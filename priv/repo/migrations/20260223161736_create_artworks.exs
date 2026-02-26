defmodule Calderaodeartesdavobruxa.Repo.Migrations.CreateArtworks do
  use Ecto.Migration

  def change do
    create table(:artworks) do
      add :name, :string
      add :description, :text
      add :style, :string
      add :category, :string
      add :subcategory, :string
      add :materials, :text
      add :width, :float
      add :depth, :float
      add :height, :float
      add :weight, :float
      add :sent_price, :integer
      add :img, :string
      add :sold, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
