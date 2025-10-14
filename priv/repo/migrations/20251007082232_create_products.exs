defmodule EcommerceLive.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :stock_quantity, :integer, default: 0, null: false
      add :image_url, :string
      add :is_active, :boolean, default: false, null: false

      # ✅ Ensure foreign key matches category binary_id
      add :category_id, references(:categories, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:category_id])
  end
end
