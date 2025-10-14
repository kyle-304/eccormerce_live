defmodule EcommerceLive.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "order_items" do
    field :quantity, :integer
    field :unit_price, :decimal
    field :subtotal, :decimal

    belongs_to :order, EcommerceLive.Orders.Order, type: :binary_id
    belongs_to :product, EcommerceLive.Catalog.Product, type: :binary_id

    timestamps()
  end

  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:quantity, :unit_price, :subtotal, :order_id, :product_id])
    |> validate_required([:quantity, :unit_price, :subtotal, :order_id, :product_id])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:unit_price, greater_than_or_equal_to: 0)
    |> validate_number(:subtotal, greater_than_or_equal_to: 0)
    |> put_change(:subtotal, calculate_subtotal(order_item))
  end

  defp calculate_subtotal(order_item) do
    unit_price = get_field(order_item, :unit_price) || Decimal.new(0)
    quantity = get_field(order_item, :quantity) || 0
    Decimal.mult(unit_price, Decimal.new(quantity))
  end
end
