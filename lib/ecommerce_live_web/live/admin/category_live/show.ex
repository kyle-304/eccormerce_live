defmodule EcommerceLiveWeb.Admin.CategoryLive.Show do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    category = Catalog.get_category!(id)

    {:ok,
     socket
     |> assign(:page_title, "View Category")
     |> assign(:category, category)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto space-y-6">
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold"><%= @category.name %></h1>

        <div class="flex space-x-2">
          <.link
            patch={~p"/admin/categories/#{@category.id}/edit"}
            class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
          >
            Edit
          </.link>

          <.link
            patch={~p"/admin/categories"}
            class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200"
          >
            Back
          </.link>
        </div>
      </div>

      <div class="bg-white shadow rounded-lg p-6 space-y-4 border border-gray-200">
        <div>
          <h2 class="text-lg font-semibold text-gray-700">Description</h2>
          <p class="text-gray-600"><%= @category.description || "—" %></p>
        </div>

        <div>
          <h2 class="text-lg font-semibold text-gray-700">Parent Category</h2>
          <p class="text-gray-600">
            <%= if @category.parent do %>
              <%= @category.parent.name %>
            <% else %>
              None
            <% end %>
          </p>
        </div>

        <div>
          <h2 class="text-lg font-semibold text-gray-700">Subcategories</h2>
          <ul class="list-disc list-inside text-gray-600">
            <%= if @category.subcategories == [] do %>
              <li>No subcategories</li>
            <% else %>
              <%= for sub <- @category.subcategories do %>
                <li><%= sub.name %></li>
              <% end %>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
