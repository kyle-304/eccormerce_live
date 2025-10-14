defmodule EcommerceLiveWeb.Admin.CategoryLive.Edit do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    category = Catalog.get_category!(id)

    {:ok,
     socket
     |> assign(:page_title, "Edit Category")
     |> assign(:category, category)
     |> assign(:action, :edit)
     |> assign(:navigate, ~p"/admin/categories")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_component
        module={EcommerceLiveWeb.Admin.CategoryLive.FormComponent}
        id={@category.id}
        category={@category}
        action={@action}
        navigate={@navigate}
      />
    </div>
    """
  end
end
