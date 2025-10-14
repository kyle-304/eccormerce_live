defmodule EcommerceLive.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :stock_quantity, :integer, default: 0
    field :image_url, :string
    field :is_active, :boolean, default: false

    belongs_to :category, EcommerceLive.Catalog.Category, type: :binary_id

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :stock_quantity, :image_url, :is_active, :category_id])
    |> validate_required([:name, :price, :category_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:stock_quantity, greater_than_or_equal_to: 0)
  end
end
