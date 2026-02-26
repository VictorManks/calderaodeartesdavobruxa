# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Calderaodeartesdavobruxa.Repo.insert!(%Calderaodeartesdavobruxa.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Dotenvy.source!([".env"]) |> System.put_env()

alias Calderaodeartesdavobruxa.Accounts.User
alias Calderaodeartesdavobruxa.Repo

%User{}
|> User.email_changeset(%{email: System.fetch_env!("ADMIN_EMAIL")}, validate_unique: false)
|> User.password_changeset(%{password: System.get_env("ADMIN_PASSWORD")})
|> Ecto.Changeset.put_change(:role, :admin)
|> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
|> Repo.insert!(on_conflict: :nothing, conflict_target: :email)

if Application.get_env(:calderaodeartesdavobruxa, :env) == :dev do
  %User{}
  |> User.email_changeset(%{email: "teste_user@gmail.com"}, validate_unique: false)
  |> User.password_changeset(%{password: "teste@teste123"})
  |> Ecto.Changeset.put_change(:role, :user)
  |> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
  |> Repo.insert!(on_conflict: :nothing, conflict_target: :email)
end
