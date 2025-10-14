defmodule EcommerceLive.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "categories" do
    field :name, :string
    field :description, :string

    belongs_to :parent, __MODULE__, foreign_key: :parent_id, type: :binary_id
    has_many :subcategories, __MODULE__, foreign_key: :parent_id

    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :parent_id])
    |> validate_required([:name])
  end
end
