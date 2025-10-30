defmodule EcommerceLive.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "payments" do
    field :payment_method, :string
    field :transaction_id, :string
    field :amount, :decimal
    field :payment_date, :utc_datetime
    field :status, :string

    belongs_to :order, EcommerceLive.Orders.Order, type: :binary_id

    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:payment_method, :transaction_id, :amount, :payment_date, :status, :order_id])
    |> validate_required([:payment_method, :transaction_id, :amount, :payment_date, :status, :order_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> unique_constraint(:transaction_id)
  end
end



