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
  Lists all orders.

  Returns a list of all orders in the system.

  ## Examples

      iex> list_orders()
      [%Order{}, %Order{}]
  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets an order by its ID.

  Raises `Ecto.NoResultsError` if the order is not found.

  ## Examples

      iex> get_order!(123)
      %Order{id: 123}

      iex> get_order!(999)
      ** (Ecto.NoResultsError)
  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a new order with the given attributes.

  Returns `{:ok, %Order{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_order(%{total_amount: 100.0})
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

      iex> update_order(order, %{status: "completed"})
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

      iex> change_order(order, %{status: "pending"})
      %Ecto.Changeset{}
  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  # ----------------------------------------------------------------
  # ORDER ITEMS
  # ----------------------------------------------------------------

  @doc """
  Lists all order items.

  Returns a list of all order items in the system.

  ## Examples

      iex> list_order_items()
      [%OrderItem{}, %OrderItem{}]
  """
  def list_order_items do
    Repo.all(OrderItem)
  end

  @doc """
  Gets an order item by its ID.

  Raises `Ecto.NoResultsError` if the order item is not found.

  ## Examples

      iex> get_order_item!(123)
      %OrderItem{id: 123}

      iex> get_order_item!(999)
      ** (Ecto.NoResultsError)
  """
  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  @doc """
  Creates a new order item with the given attributes.

  Returns `{:ok, %OrderItem{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_order_item(%{product_id: 1, quantity: 2})
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

  Returns the total amount as a decimal.

  ## Examples

      iex> calculate_order_total(order_id)
      Decimal.new("100.0")
  """
  def calculate_order_total(order_id) do
    OrderItem
    |> where(order_id: ^order_id)
    |> select([oi], sum(oi.subtotal))
    |> Repo.one()
  end

  @doc """
  Updates the order's total amount based on its order items.

  This will recalculate the total and update the `total_amount` field of the order.

  ## Examples

      iex> update_order_total(order)
      {:ok, %Order{}}
  """
  def update_order_total(%Order{} = order) do
    total = calculate_order_total(order.id) || Decimal.new(0)

    order
    |> Ecto.Changeset.change(total_amount: total)
    |> Repo.update()
  end

  @doc """
  Creates an order with multiple order items in a single transaction.

  This ensures the order and all associated items are created atomically.

  ## Examples

      iex> create_order_with_items(order_attrs, items_attrs_list)
      {:ok, %Order{}}
  """
  def create_order_with_items(order_attrs, items_attrs_list) do
    Multi.new()
    |> Multi.insert(:order, Order.changeset(%Order{}, order_attrs))
    |> Multi.run(:order_items, fn repo, %{order: order} ->
      items =
        Enum.map(items_attrs_list, fn item_attrs ->
          item_attrs = Map.put(item_attrs, :order_id, order.id)
          %OrderItem{} |> OrderItem.changeset(item_attrs)
        end)

      case Enum.map(items, &repo.insert/1) |> Enum.split_with(&match?({:ok, _}, &1)) do
        {oks, []} -> {:ok, Enum.map(oks, fn {:ok, item} -> item end)}
        {_, errors} -> {:error, List.first(errors)}
      end
    end)
    |> Multi.run(:update_total, fn _repo, %{order: order} ->
      update_order_total(order)
    end)
    |> Repo.transaction()
  end
end
