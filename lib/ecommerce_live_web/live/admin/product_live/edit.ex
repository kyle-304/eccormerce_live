defmodule EcommerceLiveWeb.Admin.ProductLive.Edit do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog
  alias EcommerceLiveWeb.Admin.ProductLive.FormComponent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    product = Catalog.get_product!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Edit Product")
     |> assign(:product, product)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <h1 class="text-2xl font-bold mb-4">Edit Product</h1>

      <.live_component
        module={FormComponent}
        id="edit-product"
        product={@product}
        action={:edit}
        navigate={~p"/admin/products"}
      />
    </div>
    """
  end
end
