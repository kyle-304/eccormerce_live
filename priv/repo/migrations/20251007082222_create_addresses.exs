defmodule EcommerceLive.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :line1, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :postal_code, :string
      add :is_default, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:addresses, [:user_id])
  end
end
