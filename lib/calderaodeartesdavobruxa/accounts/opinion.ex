defmodule Calderaodeartesdavobruxa.Accounts.Opinion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "opinions" do
    field :ratin, :integer
    field :opinion_text, :string
    field :artwork_id, :id
    field :public, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(opinion, attrs, user_scope) do
    opinion
    |> cast(attrs, [:ratin, :opinion_text, :public])
    |> validate_required([:ratin, :opinion_text])
    |> put_change(:user_id, user_scope.user.id)
  end
end
