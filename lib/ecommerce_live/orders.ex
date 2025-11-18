defmodule EcommerceLive.Orders do
  @moduledoc """
  The Orders context.

  Handles orders and order items in the e-commerce system.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias EcommerceLive.Repo
  alias EcommerceLive.Orders.{Order, OrderItem}

  # ----------------------------------------------------------------
  # ORDERS
  # ----------------------------------------------------------------

  @doc """
  Lists all orders with optional preloads.

  Returns a list of all orders in the system.

  ## Examples

      iex> list_orders()
      [%Order{}, %Order{}]

      iex> list_orders(preload: [:order_items, :user])
      [%Order{order_items: [...], user: %User{}}, ...]
  """
  def list_orders(opts \\ []) do
    Order
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  @doc """
  Lists orders for a specific user.

  ## Examples

      iex> list_user_orders(user_id)
      [%Order{}, %Order{}]
  """
  def list_user_orders(user_id, opts \\ []) do
    Order
    |> where(user_id: ^user_id)
    |> order_by(desc: :order_date)
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  @doc """
  Lists orders by status.

  ## Examples

      iex> list_orders_by_status("pending")
      [%Order{order_status: "pending"}, ...]
  """
  def list_orders_by_status(status, opts \\ []) do
    Order
    |> where(order_status: ^status)
    |> order_by(desc: :order_date)
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  @doc """
  Gets an order by its ID with optional preloads.

  Raises `Ecto.NoResultsError` if the order is not found.

  ## Examples

      iex> get_order!(123)
      %Order{id: 123}

      iex> get_order!(123, preload: [:order_items])
      %Order{id: 123, order_items: [...]}

      iex> get_order!(999)
      ** (Ecto.NoResultsError)
  """
  def get_order!(id, opts \\ []) do
    Order
    |> maybe_preload(opts[:preload])
    |> Repo.get!(id)
  end

  @doc """
  Creates a new order with the given attributes.

  Returns `{:ok, %Order{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_order(%{total_amount: 100.0, order_date: ~U[2025-01-01 00:00:00Z]})
      {:ok, %Order{}}

      iex> create_order(%{total_amount: -10})
      {:error, %Ecto.Changeset{}}
  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing order with the given attributes.

  Returns `{:ok, %Order{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> update_order(order, %{order_status: "completed"})
      {:ok, %Order{}}

      iex> update_order(order, %{total_amount: -10})
      {:error, %Ecto.Changeset{}}
  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an existing order.

  Returns `{:ok, %Order{}}` on success or `{:error, %Ecto.Changeset{}}` if there is an issue with deletion.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}
  """
  def delete_order(%Order{} = order), do: Repo.delete(order)

  @doc """
  Returns a changeset for modifying the given order.

  ## Examples

      iex> change_order(order, %{order_status: "pending"})
      %Ecto.Changeset{}
  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  # ----------------------------------------------------------------
  # ORDER ITEMS
  # ----------------------------------------------------------------

  @doc """
  Lists all order items with optional preloads.

  Returns a list of all order items in the system.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, %OrderItem{}]

      iex> list_order_items(preload: [:product])
      [%OrderItem{product: %Product{}}, ...]
  """
  def list_order_items(opts \\ []) do
    OrderItem
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  @doc """
  Lists order items for a specific order.

  ## Examples

      iex> list_order_items_for_order(order_id)
      [%OrderItem{}, %OrderItem{}]
  """
  def list_order_items_for_order(order_id, opts \\ []) do
    OrderItem
    |> where(order_id: ^order_id)
    |> maybe_preload(opts[:preload])
    |> Repo.all()
  end

  @doc """
  Gets an order item by its ID with optional preloads.

  Raises `Ecto.NoResultsError` if the order item is not found.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{id: 123}

      iex> get_order_item!(999)
      ** (Ecto.NoResultsError)
  """
  def get_order_item!(id, opts \\ []) do
    OrderItem
    |> maybe_preload(opts[:preload])
    |> Repo.get!(id)
  end

  @doc """
  Creates a new order item with the given attributes.

  Returns `{:ok, %OrderItem{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_order_item(%{product_id: 1, quantity: 2, unit_price: 10.00})
      {:ok, %OrderItem{}}

      iex> create_order_item(%{product_id: 1, quantity: -1})
      {:error, %Ecto.Changeset{}}
  """
  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an existing order item with the given attributes.

  Returns `{:ok, %OrderItem{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> update_order_item(order_item, %{quantity: 3})
      {:ok, %OrderItem{}}

      iex> update_order_item(order_item, %{quantity: -1})
      {:error, %Ecto.Changeset{}}
  """
  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an existing order item.

  Returns `{:ok, %OrderItem{}}` on success or `{:error, %Ecto.Changeset{}}` if there is an issue with deletion.

  ## Examples

      iex> delete_order_item(order_item)
      {:ok, %OrderItem{}}
  """
  def delete_order_item(%OrderItem{} = order_item), do: Repo.delete(order_item)

  @doc """
  Returns a changeset for modifying the given order item.

  ## Examples

      iex> change_order_item(order_item, %{quantity: 5})
      %Ecto.Changeset{}
  """
  def change_order_item(%OrderItem{} = order_item, attrs \\ %{}) do
    OrderItem.changeset(order_item, attrs)
  end

  # ------------------------------
  # UTILITIES
  # ------------------------------

  @doc """
  Calculates the total amount for an order by summing its order items.

  Returns the total amount as a decimal or Decimal.new(0) if no items exist.

  ## Examples

      iex> calculate_order_total(order_id)
      Decimal.new("100.0")
  """
  def calculate_order_total(order_id) do
    OrderItem
    |> where(order_id: ^order_id)
    |> select([oi], sum(oi.subtotal))
    |> Repo.one()
    |> case do
      nil -> Decimal.new(0)
      total -> total
    end
  end

  @doc """
  Updates the order's total amount based on its order items.

  This will recalculate the total and update the `total_amount` field of the order.

  ## Examples

      iex> update_order_total(order)
      {:ok, %Order{}}
  """
  def update_order_total(%Order{} = order) do
    total = calculate_order_total(order.id)

    order
    |> Ecto.Changeset.change(total_amount: total)
    |> Repo.update()
  end

  @doc """
  Creates an order with multiple order items in a single transaction.

  This ensures the order and all associated items are created atomically.
  The order's total_amount will be automatically calculated from the items.

  ## Examples

      iex> order_attrs = %{
      ...>   order_date: ~U[2025-01-01 00:00:00Z],
      ...>   payment_status: "pending",
      ...>   order_status: "pending",
      ...>   user_id: user_id,
      ...>   address_id: address_id
      ...> }
      iex> items_attrs = [
      ...>   %{product_id: product1_id, quantity: 2, unit_price: Decimal.new("10.00")},
      ...>   %{product_id: product2_id, quantity: 1, unit_price: Decimal.new("25.00")}
      ...> ]
      iex> create_order_with_items(order_attrs, items_attrs)
      {:ok, %{order: %Order{}, order_items: [%OrderItem{}, ...], update_total: %Order{}}}
  """
  def create_order_with_items(order_attrs, items_attrs_list) do
    # Set initial total_amount to 0
    order_attrs = Map.put(order_attrs, :total_amount, Decimal.new(0))

    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, order_attrs))
    |> Multi.run(:order_items, fn repo, %{order: order} ->
      insert_order_items(repo, order, items_attrs_list)
    end)
    |> Multi.run(:update_total, fn _repo, %{order: order} ->
      update_order_total(order)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, result.update_total}
      {:error, _operation, changeset, _changes} -> {:error, changeset}
    end
  end

  # Private helper to insert order items
  defp insert_order_items(repo, order, items_attrs_list) do
    results =
      Enum.map(items_attrs_list, fn item_attrs ->
        item_attrs = Map.put(item_attrs, :order_id, order.id)

        %OrderItem{}
        |> OrderItem.changeset(item_attrs)
        |> repo.insert()
      end)

    # Check if all insertions succeeded
    case Enum.split_with(results, &match?({:ok, _}, &1)) do
      {oks, []} ->
        items = Enum.map(oks, fn {:ok, item} -> item end)
        {:ok, items}

      {_oks, [error | _rest]} ->
        error
    end
  end

  # Private helper for conditional preloading
  defp maybe_preload(query, nil), do: query
  defp maybe_preload(query, []), do: query
  defp maybe_preload(query, preloads) when is_list(preloads) do
    Ecto.Query.preload(query, ^preloads)
  end
  defp maybe_preload(query, preload) do
    Ecto.Query.preload(query, ^preload)
  end
end
