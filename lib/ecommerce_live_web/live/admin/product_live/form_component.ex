defmodule EcommerceLiveWeb.Admin.ProductLive.Form do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Catalog
  # alias EcommerceLive.Uploaders.ProductImage
  alias EcommerceLive.Catalog.Product

  # ----------------------------------------
  # MOUNT
  # ----------------------------------------
  def mount(_params, _session, socket) do
    categories = Catalog.list_categories()

    {:ok,
     socket
     |> assign(:categories, categories)
     |> assign(:page_title, "")
     |> assign(:product, %Product{})
     |> assign(:form, to_form(Catalog.change_product(%Product{})))}
  end

  # ----------------------------------------
  # HANDLE PARAMS
  # ----------------------------------------
  def handle_params(%{"id" => id}, _url, socket) do
    product = Catalog.get_product!(id)
    changeset = Catalog.change_product(product)

    {:noreply,
     socket
     |> assign(:page_title, "Edit Product")
     |> assign(:product, product)
     |> assign(:action, :edit)
     |> assign(:form, to_form(changeset))}
  end

  def handle_params(_params, _url, socket) do
    changeset = Catalog.change_product(%Product{})

    {:noreply,
     socket
     |> assign(:page_title, "New Product")
     |> assign(:product, %Product{})
     |> assign(:action, :new)
     |> assign(:form, to_form(changeset))}
  end

  # ----------------------------------------
  # VALIDATION
  # ----------------------------------------
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  # ----------------------------------------
  # SAVE (NEW OR EDIT)
  # ----------------------------------------
  def handle_event("save", %{"product" => product_params}, socket) do
    case socket.assigns.action do
      :new ->
        create_product(socket, product_params)

      :edit ->
        update_product(socket, product_params)
    end
  end

  defp create_product(socket, params) do
    case Catalog.create_product(params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_navigate(to: ~p"/admin/products")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_product(socket, params) do
    case Catalog.update_product(socket.assigns.product, params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_navigate(to: ~p"/admin/products")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  # ----------------------------------------
  # RENDER
  # ----------------------------------------
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6 space-y-6 bg-white rounded-xl shadow">
      <h1 class="text-2xl font-bold">
        <%= if @action == :edit, do: "Edit Product", else: "New Product" %>
      </h1>

      <.form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:price]} type="number" step="0.01" label="Price" />
        <.input field={@form[:stock_quantity]} type="number" label="Stock Quantity" />

        <div>
          <label class="block mb-1 font-medium text-gray-700">Category</label>
          <select name="product[category_id]" class="w-full border rounded-lg px-3 py-2">
            <option value="">Select category</option>
            <%= for category <- @categories do %>
              <option
                value={category.id}
                selected={@form[:category_id].value == category.id}
              >
                <%= category.name %>
              </option>
            <% end %>
          </select>
        </div>

        <.input field={@form[:image_url]} label="Image URL" />

        <div class="flex items-center gap-2">
          <label class="font-medium text-gray-700">Active?</label>
          <input
            type="checkbox"
            name="product[is_active]"
            value="true"
            checked={@form[:is_active].value}
          />
        </div>

        <div class="flex justify-end gap-2 pt-4">
          <.link navigate={~p"/admin/products"} class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200">
            Cancel
          </.link>
          <.button phx-disable-with="Saving..." class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">
            Save
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
