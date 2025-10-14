defmodule EcommerceLive.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_date, :utc_datetime, null: false
      add :total_amount, :decimal, precision: 10, scale: 2, null: false
      add :payment_status, :string, null: false
      add :order_status, :string, null: false

      # ✅ Ensure these foreign keys use :binary_id to match users & addresses
      add :user_id, references(:users, on_delete: :nothing)
      add :address_id, references(:addresses, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:user_id])
    create index(:orders, [:address_id])
  end
end
