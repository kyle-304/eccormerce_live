defmodule EcommerceLive.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :payment_method, :string, null: false
      add :transaction_id, :string, null: false
      add :amount, :decimal, precision: 10, scale: 2, null: false
      add :payment_date, :utc_datetime, null: false
      add :status, :string, null: false

      # ✅ Match foreign key type with orders.id (binary_id)
      add :order_id, references(:orders, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:payments, [:transaction_id])
    create index(:payments, [:order_id])
  end
end
