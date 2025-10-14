defmodule EcommerceLiveWeb.Admin.ProductLive.Index do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog
  alias EcommerceLive.Catalog.Product

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:products, list_products())
     |> assign(:term, "")}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("search", %{"term" => term}, socket) do
    term = String.trim(term || "")

    products =
      if term == "" do
        Catalog.list_products()
      else
        Catalog.search_products(term)
      end

    {:noreply, assign(socket, products: products, term: term)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)
    {:noreply, assign(socket, :products, list_products())}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
    |> assign(:action, :edit)
    |> assign(:navigate, ~p"/admin/products")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
    |> assign(:action, :new)
    |> assign(:navigate, ~p"/admin/products")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Products")
    |> assign(:product, nil)
    |> assign(:action, :index)
  end

  defp list_products do
    Catalog.list_products()
    |> EcommerceLive.Repo.preload(:category)
  end
end
