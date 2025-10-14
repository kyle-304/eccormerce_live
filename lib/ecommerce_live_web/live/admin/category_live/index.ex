defmodule EcommerceLiveWeb.Admin.CategoryLive.Index do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Categories")
     |> assign(:term, "")
     |> assign(:categories, Catalog.list_categories())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    category = Catalog.get_category!(id)
    {:ok, _} = Catalog.delete_category(category)

    {:noreply,
     socket
     |> put_flash(:info, "Category deleted successfully")
     |> assign(:categories, Catalog.list_categories())}
  end

  @impl true
  def handle_event("search", %{"term" => term}, socket) do
  term = String.trim(term || "")

  categories =
    if term == "" do
      Catalog.list_categories()
    else
      Catalog.search_categories(term)
    end

  {:noreply, assign(socket, term: term, categories: categories)}
end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50 p-6">
      <!-- Main container -->
      <div class="max-w-6xl mx-auto">

    <!-- Header section -->
        <div class="mb-8">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 class="text-3xl font-bold text-gray-900">Categories</h1>
              <p class="mt-2 text-gray-600">Organize your products with categories</p>
            </div>

    <!-- New category button -->
            <.link
              patch={~p"/admin/categories/new"}
              class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2.5 rounded-lg transition-colors duration-200 shadow-sm hover:shadow-md font-medium"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                >
                </path>
              </svg>
              New Category
            </.link>
          </div>
        </div>

    <!-- Search section -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
          <h2 class="text-lg font-semibold text-gray-800 mb-4">Find Categories</h2>
          <form phx-change="search" class="max-w-md">
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <svg
                  class="h-5 w-5 text-gray-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                  >
                  </path>
                </svg>
              </div>
              <input
                type="text"
                name="term"
                placeholder="Search by category name or description..."
                value={@term || ""}
                class="block w-full pl-10 pr-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors duration-200"
                phx-debounce="300"
              />
            </div>
          </form>
        </div>

    <!-- Categories table section -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <div>
                <h2 class="text-lg font-semibold text-gray-800">All Categories</h2>
                <p class="text-sm text-gray-600 mt-1">
                  <%= if length(@categories) == 1 do %>
                    Showing 1 category
                  <% else %>
                    Showing {length(@categories)} categories
                  <% end %>
                </p>
              </div>
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <div class="flex items-center gap-2">
                      <span>Category Name</span>
                    </div>
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Description
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <%= for category <- @categories do %>
                  <tr class="hover:bg-gray-50 transition-colors duration-150 group">
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center gap-3">
                        <div class="flex-shrink-0 h-10 w-10 bg-gradient-to-br from-blue-100 to-blue-200 rounded-lg flex items-center justify-center">
                          <svg
                            class="h-5 w-5 text-blue-600"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                            >
                            </path>
                          </svg>
                        </div>
                        <div>
                          <div class="text-sm font-semibold text-gray-900">{category.name}</div>
                          <div class="text-xs text-gray-500">ID: {category.id}</div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-4">
                      <div class="text-sm text-gray-600 max-w-md">
                        <%= if category.description do %>
                          {category.description}
                        <% else %>
                          <span class="text-gray-400 italic">No description provided</span>
                        <% end %>
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center space-x-3">
                        <.link
                          patch={~p"/admin/categories/#{category.id}/edit"}
                          class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-900 transition-colors duration-200 font-medium text-sm"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                            >
                            </path>
                          </svg>
                          Edit
                        </.link>

                        <span class="text-gray-300">•</span>

                        <a
                          href="#"
                          phx-click="delete"
                          phx-value-id={category.id}
                          data-confirm="Are you sure you want to delete this category? This action cannot be undone."
                          class="inline-flex items-center gap-1 text-red-600 hover:text-red-900 transition-colors duration-200 font-medium text-sm"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                            >
                            </path>
                          </svg>
                          Delete
                        </a>
                      </div>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>

    <!-- Empty state -->
          <%= if Enum.empty?(@categories) do %>
            <div class="text-center py-12">
              <div class="mx-auto h-16 w-16 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                <svg
                  class="h-8 w-8 text-gray-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                  >
                  </path>
                </svg>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">No categories found</h3>
              <p class="text-gray-500 max-w-sm mx-auto mb-6">
                <%= if @term do %>
                  No categories match your search criteria. Try adjusting your search terms.
                <% else %>
                  Categories help you organize your products. Create your first category to get started.
                <% end %>
              </p>
              <.link
                patch={~p"/admin/categories/new"}
                class="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2.5 rounded-lg transition-colors duration-200 font-medium"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                  >
                  </path>
                </svg>
                Create First Category
              </.link>
            </div>
          <% end %>
        </div>

    <!-- Quick stats (optional enhancement) -->
        <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
          <div class="bg-white rounded-lg p-4 shadow-sm border border-gray-200">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                  <svg
                    class="h-6 w-6 text-blue-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                    >
                    </path>
                  </svg>
                </div>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Total Categories</p>
                <p class="text-2xl font-bold text-gray-900">{length(@categories)}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
