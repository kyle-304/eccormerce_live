defmodule EcommerceLive.Cart do
  @moduledoc """
  The Carts context.

  Handles shopping cart and cart items management for users.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Carts.{Cart, CartItem}
  alias EcommerceLive.Catalog.Product

  # ----------------------------------------------------------------
  # CARTS
  # ----------------------------------------------------------------

  @spec list_carts() :: [Cart.t()]
  def list_carts do
    Repo.all(Cart)
  end

  @spec get_cart!(Ecto.UUID.t()) :: Cart.t()
  def get_cart!(id), do: Repo.get!(Cart, id)

  @spec get_user_cart(Ecto.UUID.t()) :: Cart.t() | nil
  def get_user_cart(user_id) do
    Cart
    |> where(user_id: ^user_id)
    |> preload(cart_items: [:product])
    |> Repo.one()
  end

  @spec create_cart(map()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_cart(Cart.t()) :: {:ok, Cart.t()} | {:error, Ecto.Changeset.t()}
  def delete_cart(%Cart{} = cart), do: Repo.delete(cart)

  @spec change_cart(Cart.t(), map()) :: Ecto.Changeset.t()
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  # ----------------------------------------------------------------
  # CART ITEMS
  # ----------------------------------------------------------------

  @spec list_cart_items() :: [CartItem.t()]
  def list_cart_items do
    Repo.all(CartItem)
  end

  @spec get_cart_item!(Ecto.UUID.t()) :: CartItem.t()
  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  @spec add_item_to_cart(Ecto.UUID.t(), map()) ::
          {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def add_item_to_cart(cart_id, %{product_id: product_id, quantity: quantity}) do
    case Repo.get_by(CartItem, cart_id: cart_id, product_id: product_id) do
      nil ->
        %CartItem{}
        |> CartItem.changeset(%{cart_id: cart_id, product_id: product_id, quantity: quantity})
        |> Repo.insert()

      %CartItem{} = existing_item ->
        update_cart_item(existing_item, %{quantity: existing_item.quantity + quantity})
    end
  end

  @spec update_cart_item(CartItem.t(), map()) ::
          {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  @spec remove_item_from_cart(CartItem.t()) ::
          {:ok, CartItem.t()} | {:error, Ecto.Changeset.t()}
  def remove_item_from_cart(%CartItem{} = cart_item), do: Repo.delete(cart_item)

  @spec clear_cart(Ecto.UUID.t()) :: :ok
  def clear_cart(cart_id) do
    from(ci in CartItem, where: ci.cart_id == ^cart_id)
    |> Repo.delete_all()

    :ok
  end

  # ----------------------------------------------------------------
  # UTILITIES
  # ----------------------------------------------------------------

  @spec get_cart_total(Cart.t()) :: Decimal.t()
  def get_cart_total(%Cart{} = cart) do
    cart = Repo.preload(cart, cart_items: [:product])

    Enum.reduce(cart.cart_items, Decimal.new(0), fn item, acc ->
      product_price =
        case item.product do
          %Product{price: price} -> price
          _ -> Decimal.new(0)
        end

      item_total = Decimal.mult(product_price, Decimal.new(item.quantity))
      Decimal.add(acc, item_total)
    end)
  end
end
