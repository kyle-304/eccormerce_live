defmodule EcommerceLiveWeb.Admin.OrderLive.Edit do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Orders

  def mount(%{"id" => id}, _session, socket) do
    order = Orders.get_order!(id)
    changeset = Orders.change_order(order)

    {:ok, assign(socket, order: order, changeset: changeset)}
  end

  def handle_event("validate", %{"order" => params}, socket) do
    changeset =
      socket.assigns.order
      |> Orders.change_order(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"order" => params}, socket) do
    case Orders.update_order(socket.assigns.order, params) do
      {:ok, order} ->
        {:noreply,
         socket
         |> put_flash(:info, "Order updated")
         |> push_navigate(to: ~p"/admin/orders/#{order.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
