defmodule EcommerceLive.Orders do
  @moduledoc """
  The Orders context.

  Handles orders and order items in the e-commerce system.
  """

  import Ecto.Query, warn: false
  import Ecto.Multi
  alias EcommerceLive.Repo
  alias EcommerceLive.Orders.{Order, OrderItem}

  # ----------------------------------------------------------------
  # ORDERS
  # ----------------------------------------------------------------

  def list_orders do
    Repo.all(Order)
  end

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def delete_order(%Order{} = order), do: Repo.delete(order)

  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  # ----------------------------------------------------------------
  # ORDER ITEMS
  # ----------------------------------------------------------------

  def list_order_items do
    Repo.all(OrderItem)
  end

  def get_order_item!(id), do: Repo.get!(OrderItem, id)

  def create_order_item(attrs \\ %{}) do
    %OrderItem{}
    |> OrderItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_order_item(%OrderItem{} = order_item, attrs) do
    order_item
    |> OrderItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_order_item(%OrderItem{} = order_item), do: Repo.delete(order_item)

  @spec change_order_item(OrderItem.t(), map()) :: Ecto.Changeset.t()
  def change_order_item(%OrderItem{} = order_item, attrs \\ %{}) do
    OrderItem.changeset(order_item, attrs)
  end

  # ----------------------------------------------------------------
  # UTILITIES
  # ----------------------------------------------------------------

  @doc """
  Calculates the total amount for an order by summing its order items.
  """
  def calculate_order_total(order_id) do
    OrderItem
    |> where(order_id: ^order_id)
    |> select([oi], sum(oi.subtotal))
    |> Repo.one()
  end

  @doc """
  Updates the order's total amount based on its order items.
  """
  def update_order_total(%Order{} = order) do
    total = calculate_order_total(order.id) || Decimal.new(0)

    order
    |> Ecto.Changeset.change(total_amount: total)
    |> Repo.update()
  end

  @doc """
  Creates an order with multiple order items in a single transaction.
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
