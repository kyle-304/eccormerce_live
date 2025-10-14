defmodule EcommerceLive.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :rating, :integer, null: false
      add :comment, :text
      add :created_at, :utc_datetime, null: false, default: fragment("now()")

      # ✅ Match foreign key types with UUIDs
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :product_id, references(:products, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:reviews, [:user_id])
    create index(:reviews, [:product_id])
    create unique_index(:reviews, [:user_id, :product_id]) # one review per user per product
  end
end
