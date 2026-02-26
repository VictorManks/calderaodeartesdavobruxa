defmodule Calderaodeartesdavobruxa.Accounts.Opinion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "opinions" do
    field :ratin, :integer
    field :opinion_text, :string
    belongs_to :artwork, Calderaodeartesdavobruxa.Gallery.Artwork
    field :public, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(opinion, attrs, user_scope) do
    opinion
    |> cast(attrs, [:ratin, :opinion_text, :public, :artwork_id])
    |> validate_required([:ratin, :opinion_text, :artwork_id])
    |> validate_inclusion(:ratin, 1..5, message: "deve ser entre 1 e 5")
    |> put_change(:user_id, user_scope.user.id)
    |> unsafe_validate_unique([:user_id, :artwork_id], Calderaodeartesdavobruxa.Repo,
      message: "você já publicou uma opinião sobre esta obra"
    )
    |> unique_constraint([:user_id, :artwork_id],
      message: "você já publicou uma opinião sobre esta obra"
    )
  end
end
