defmodule EcommerceLiveWeb.Admin.ProductLive.Show do
  use EcommerceLiveWeb, :live_view
  alias EcommerceLive.Catalog

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    product = Catalog.get_product!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Product Details")
     |> assign(:product, product)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold"><%= @product.name %></h1>
        <.link
          patch={~p"/admin/products/#{@product.id}/edit"}
          class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
        >
          ✏️ Edit
        </.link>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <img
            src={EcommerceLive.Uploaders.ProductImage.url(@product.image, :original) || @product.image_url || "/images/placeholder.png"}
            alt={@product.name}
            class="rounded-xl shadow-lg w-full"
          />
        </div>

        <div class="space-y-2">
          <p><strong>Description:</strong> <%= @product.description || "—" %></p>
          <p><strong>Price:</strong> $<%= @product.price %></p>
          <p><strong>Stock Quantity:</strong> <%= @product.stock_quantity %></p>
          <p><strong>Category:</strong> <%= @product.category && @product.category.name || "—" %></p>
          <p><strong>Status:</strong> <%= if @product.is_active, do: "Active", else: "Inactive" %></p>
        </div>
      </div>

      <div>
        <.link
          navigate={~p"/admin/products"}
          class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          ← Back to Products
        </.link>
      </div>
    </div>
    """
  end
end
