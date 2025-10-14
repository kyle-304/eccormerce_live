defmodule EcommerceLive.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "carts" do
    field :created_at, :utc_datetime

    belongs_to :user, EcommerceLive.Accounts.User, type: :binary_id
    has_many :cart_items, EcommerceLive.Carts.CartItem, foreign_key: :cart_id

    timestamps(type: :utc_datetime)
  end

  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
