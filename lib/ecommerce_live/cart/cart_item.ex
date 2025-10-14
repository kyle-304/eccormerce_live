defmodule EcommerceLive.Carts.CartItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "cart_items" do
    field :quantity, :integer, default: 1

    belongs_to :cart, EcommerceLive.Carts.Cart, type: :binary_id
    belongs_to :product, EcommerceLive.Catalog.Product, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(cart_item, attrs) do
    cart_item
    |> cast(attrs, [:quantity, :cart_id, :product_id])
    |> validate_required([:quantity, :cart_id, :product_id])
    |> validate_number(:quantity, greater_than: 0)
    |> unique_constraint([:cart_id, :product_id])
  end
end
