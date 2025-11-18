defmodule EcommerceLiveWeb.Admin.OrderLive.Show do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Orders

  def mount(%{"id" => id}, _session, socket) do
    {:ok, load(id, socket)}
  end

  defp load(id, socket) do
    order =
      Orders.get_order!(id,
        preload: [
          :user,
          :address,
          order_items: [:product]
        ]
      )

    assign(socket, order: order)
  end
end
