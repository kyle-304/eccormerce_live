defmodule EcommerceLive.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "reviews" do
    field :rating, :integer
    field :comment, :string
    field :created_at, :utc_datetime

    belongs_to :user, EcommerceLive.Accounts.User, type: :binary_id
    belongs_to :product, EcommerceLive.Catalog.Product, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(review, attrs) do
    review
    |> cast(attrs, [:rating, :comment, :user_id, :product_id])
    |> validate_required([:rating, :user_id, :product_id])
    |> validate_inclusion(:rating, 1..5)
    |> unique_constraint([:user_id, :product_id])
  end
end
