defmodule EcommerceLiveWeb.Admin.ProductLive.New do
  use EcommerceLiveWeb, :live_view

  
  alias EcommerceLive.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "New Product")
     |> assign(:product, %Product{})
     |> assign(:action, :new)
     |> assign(:navigate, ~p"/admin/products")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto">
      <h1 class="text-2xl font-bold mb-6">New Product</h1>

      <.live_component
        module={EcommerceLiveWeb.Admin.ProductLive.FormComponent}
        id="new-product"
        product={@product}
        action={@action}
        navigate={@navigate}
      />
    </div>
    """
  end
end
