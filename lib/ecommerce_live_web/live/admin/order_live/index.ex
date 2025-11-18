defmodule EcommerceLiveWeb.Admin.OrderLive.Index do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Orders

  def mount(_params, _session, socket) do
    {:ok, load(socket)}
  end

  def handle_event("refresh", _, socket) do
    {:noreply, load(socket)}
  end

  defp load(socket) do
    orders =
      Orders.list_orders(preload: [:user, :address])

    assign(socket, orders: orders)
  end
end
