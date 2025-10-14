defmodule EcommerceLive.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :parent_id, references(:categories, type: :binary_id, on_delete: :nilify_all)
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:categories, [:parent_id])
  end
end
