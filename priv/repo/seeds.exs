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

alias Calderaodeartesdavobruxa.Accounts.User
alias Calderaodeartesdavobruxa.Repo

%User{}
|> User.email_changeset(%{email: "victorfdefariaq@gmail.com"}, validate_unique: false)
|> User.password_changeset(%{password: "BlogDaVeia@2026"})
|> Ecto.Changeset.put_change(:role, :admin)
|> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
|> Repo.insert!(on_conflict: :nothing, conflict_target: :email)

%User{}
|> User.email_changeset(%{email: "teste_user@gmail.com"}, validate_unique: false)
|> User.password_changeset(%{password: "teste@teste123"})
|> Ecto.Changeset.put_change(:role, :user)
|> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
|> Repo.insert!(on_conflict: :nothing, conflict_target: :email)
