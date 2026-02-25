defmodule Calderaodeartesdavobruxa.Gallery.Artwork do
  use Ecto.Schema
  import Ecto.Changeset

  schema "artworks" do
    field :name, :string
    field :description, :string
    field :style, :string
    field :category, :string
    field :subcategory, :string
    field :materials, :string
    field :width, :float
    field :depth, :float
    field :height, :float
    field :weight, :float
    field :sent_price, :integer
    field :img, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(artwork, attrs) do
    artwork
    |> cast(attrs, [:name, :description, :style, :category, :subcategory, :materials, :width, :depth, :height, :weight, :sent_price, :img])
    |> validate_required([:name, :description, :style, :category, :subcategory, :materials, :width, :depth, :height, :weight, :sent_price, :img])
  end
end
