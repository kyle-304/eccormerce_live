defmodule EcommerceLive.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "orders" do
    field :order_date, :utc_datetime
    field :total_amount, :decimal
    field :payment_status, :string
    field :order_status, :string

    belongs_to :user, EcommerceLive.Accounts.User, type: :binary_id
    belongs_to :address, EcommerceLive.Accounts.Address, type: :binary_id

    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:order_date, :total_amount, :payment_status, :order_status, :user_id, :address_id])
    |> validate_required([:order_date, :total_amount, :payment_status, :order_status, :user_id, :address_id])
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)
  end
end
