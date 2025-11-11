defmodule EcommerceLive.Cart do
  @moduledoc """
  The Carts context.

  Handles shopping cart and cart items management for users.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Carts.{Cart, CartItem}
  alias EcommerceLive.Catalog.Product

  # -----------------------------
  # CARTS
  # -----------------------------

  @doc """
  Returns a list of all carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, %Cart{}]
  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a cart by its ID.

  Raises `Ecto.NoResultsError` if the cart is not found.

  ## Examples

      iex> get_cart!(123)
      %Cart{id: 123}

      iex> get_cart!(999)
      ** (Ecto.NoResultsError)
  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Gets the cart for a specific user by their user ID.

  Returns `nil` if no cart is found for the user.

  ## Examples

      iex> get_user_cart(user_id)
      %Cart{id: 123}

      iex> get_user_cart(non_existing_user_id)
      nil
  """
  def get_user_cart(user_id) do
    Cart
    |> where(user_id: ^user_id)
    |> preload(cart_items: [:product])
    |> Repo.one()
  end

  @doc """
  Creates a new cart with the given attributes.

  ## Examples

      iex> create_cart(%{user_id: 123})
      {:ok, %Cart{}}

      iex> create_cart(%{user_id: nil})
      {:error, %Ecto.Changeset{}}
  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given cart.

  Returns `{:ok, %Cart{}}` on success, or `{:error, %Ecto.Changeset{}}` on failure.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(invalid_cart)
      {:error, %Ecto.Changeset{}}
  """
  def delete_cart(%Cart{} = cart), do: Repo.delete(cart)

  @doc """
  Returns a changeset for modifying the given cart.

  ## Examples

      iex> change_cart(cart, %{user_id: 456})
      %Ecto.Changeset{}
  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  # --------------------------
  # CART ITEMS
  # --------------------------

  @doc """
  Returns a list of all cart items.

  ## Examples

      iex> list_cart_items()
      [%CartItem{}, %CartItem{}]
  """
  def list_cart_items do
    Repo.all(CartItem)
  end

  @doc """
  Gets a cart item by its ID.

  Raises `Ecto.NoResultsError` if the cart item is not found.

  ## Examples

      iex> get_cart_item!(123)
      %CartItem{id: 123}

      iex> get_cart_item!(999)
      ** (Ecto.NoResultsError)
  """
  def get_cart_item!(id), do: Repo.get!(CartItem, id)

  @doc """
  Adds an item to the cart, or updates the quantity if the item already exists.

  Returns `{:ok, %CartItem{}}` on success, or `{:error, %Ecto.Changeset{}}` on failure.

  ## Examples

      iex> add_item_to_cart(cart_id, %{product_id: 1, quantity: 2})
      {:ok, %CartItem{}}

      iex> add_item_to_cart(cart_id, %{product_id: 1, quantity: -1})
      {:error, %Ecto.Changeset{}}
  """
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

  @doc """
  Updates the attributes of a cart item.

  Returns `{:ok, %CartItem{}}` on success, or `{:error, %Ecto.Changeset{}}` on failure.

  ## Examples

      iex> update_cart_item(cart_item, %{quantity: 5})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{quantity: -1})
      {:error, %Ecto.Changeset{}}
  """
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Removes a cart item from the cart.

  Returns `{:ok, %CartItem{}}` on success, or `{:error, %Ecto.Changeset{}}` on failure.

  ## Examples

      iex> remove_item_from_cart(cart_item)
      {:ok, %CartItem{}}
  """
  def remove_item_from_cart(%CartItem{} = cart_item), do: Repo.delete(cart_item)

  @doc """
  Clears all items from the cart.

  Returns `:ok` after clearing the cart.

  ## Examples

      iex> clear_cart(cart_id)
      :ok
  """
  def clear_cart(cart_id) do
    from(ci in CartItem, where: ci.cart_id == ^cart_id)
    |> Repo.delete_all()

    :ok
  end

  # ------------------------
  # UTILITIES
  # ------------------------

  @doc """
  Calculates the total price of all items in the cart.

  ## Examples

      iex> get_cart_total(cart)
      #Decimal<100.00>
  """
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
