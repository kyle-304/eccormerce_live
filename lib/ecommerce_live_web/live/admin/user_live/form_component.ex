defmodule EcommerceLiveWeb.Admin.UserLive.Form do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Accounts
  alias EcommerceLive.Accounts.User

  @roles [:admin, :customer]

  # ------------------------------
  # MOUNT
  # ------------------------------
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "")
     |> assign(:user, %User{})
     |> assign(:action, :new)
     |> assign(:form, to_form(Accounts.change_user(%User{})))
     |> assign(:roles, @roles)}
  end

  # ------------------------------
  # HANDLE PARAMS
  # ------------------------------
  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)

    {:noreply,
     socket
     |> assign(:page_title, "Edit User")
     |> assign(:user, user)
     |> assign(:action, :edit)
     |> assign(:form, to_form(changeset))}
  end

  def handle_params(_params, _url, socket) do
    changeset = Accounts.change_user(%User{})

    {:noreply,
     socket
     |> assign(:page_title, "New User")
     |> assign(:user, %User{})
     |> assign(:action, :new)
     |> assign(:form, to_form(changeset))}
  end

  # ------------------------------
  # VALIDATION
  # ------------------------------
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  # ------------------------------
  # SAVE
  # ------------------------------
  def handle_event("save", %{"user" => user_params}, socket) do
    case socket.assigns.action do
      :new -> create_user(socket, user_params)
      :edit -> update_user(socket, user_params)
    end
  end

  defp create_user(socket, params) do
    case Accounts.register_user(params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_navigate(to: ~p"/admin/users")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_user(socket, params) do
    case Accounts.update_user(socket.assigns.user, params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_navigate(to: ~p"/admin/users")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  # ------------------------------
  # RENDER
  # ------------------------------
  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto p-6 space-y-6 bg-white rounded-xl shadow">
      <h1 class="text-2xl font-bold">
        <%= if @action == :edit, do: "Edit User", else: "New User" %>
      </h1>

      <.form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        class="space-y-4"
      >
        <.input field={@form[:email]} label="Email" type="email" />
        <.input field={@form[:phone]} label="Phone" type="tel" />

        <div>
          <label class="block mb-1 font-medium text-gray-700">Role</label>
          <select
            name="user[role]"
            class="w-full border rounded-lg px-3 py-2"
          >
            <%= for role <- @roles do %>
              <option value={role} selected={@form[:role].value == role}><%= role %></option>
            <% end %>
          </select>
        </div>

        <.input field={@form[:password]} label="Password" type="password" />
        <.input field={@form[:password_confirmation]} label="Confirm Password" type="password" />

        <div class="flex justify-end gap-2 pt-4">
          <.link navigate={~p"/admin/users"} class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200">
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
