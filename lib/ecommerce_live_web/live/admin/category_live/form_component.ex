defmodule EcommerceLiveWeb.Admin.CategoryLive.FormComponent do
  use EcommerceLiveWeb, :live_component

  alias EcommerceLive.Catalog

  @impl true
  def update(%{category: category} = assigns, socket) do
    categories = Catalog.list_categories()
    changeset = Catalog.change_category(category)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:categories, categories)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset =
      socket.assigns.category
      |> Catalog.change_category(category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"category" => category_params}, socket) do
    save_category(socket, socket.assigns.action, category_params)
  end

  defp save_category(socket, :edit, category_params) do
    case Catalog.update_category(socket.assigns.category, category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_category(socket, :new, category_params) do
    case Catalog.create_category(category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6 space-y-6 bg-white rounded-xl shadow">
      <h1 class="text-2xl font-bold">
        {if @action == :edit, do: "Edit Category", else: "New Category"}
      </h1>

      <.form
        for={@form}
        id="category-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />

        <div>
          <label class="block mb-1 font-medium text-gray-700">Parent Category</label>
          <select
            name="category[parent_id]"
            class="w-full border rounded-lg px-3 py-2"
          >
            <option value="">None (Root Category)</option>
            <%= for category <- @categories do %>
              <option
                value={category.id}
                selected={@form[:parent_id].value == category.id}
              >
                {category.name}
              </option>
            <% end %>
          </select>
        </div>

        <div class="flex justify-end gap-2 pt-4">
          <.link
            patch={@navigate}
            class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200"
          >
            Cancel
          </.link>
          <.button
            phx-disable-with="Saving..."
            class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
          >
            Save
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
