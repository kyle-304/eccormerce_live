defmodule EcommerceLive.Accounts.Address do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "addresses" do
    field :line1, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :postal_code, :string
    field :is_default, :boolean, default: false

    belongs_to :user, EcommerceLive.Accounts.User

    timestamps()
  end

  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:line1, :city, :state, :country, :postal_code, :is_default])
    |> validate_required([:line1, :city, :state, :country, :postal_code, :is_default])
  end
end
