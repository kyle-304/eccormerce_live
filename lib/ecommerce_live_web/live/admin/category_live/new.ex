defmodule EcommerceLiveWeb.Admin.CategoryLive.New do
  use EcommerceLiveWeb, :live_view

  # alias EcommerceLive.Catalog
  alias EcommerceLive.Catalog.Category

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "New Category")
     |> assign(:category, %Category{})
     |> assign(:action, :new)
     |> assign(:navigate, ~p"/admin/categories")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto">
      <h1 class="text-2xl font-bold mb-6">New Category</h1>

      <.live_component
        module={EcommerceLiveWeb.Admin.CategoryLive.FormComponent}
        id="new-category"
        category={@category}
        action={@action}
        navigate={@navigate}
      />
    </div>
    """
  end
end
