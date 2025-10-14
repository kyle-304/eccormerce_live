defmodule EcommerceLive.Repo.Migrations.CreateCarts do
  use Ecto.Migration

  def change do
    create table(:carts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :created_at, :utc_datetime, null: false, default: fragment("now()")

      # ✅ Match foreign key type with users.id (binary_id)
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:carts, [:user_id])
  end
end
