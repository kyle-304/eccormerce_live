defmodule EcommerceLiveWeb.Admin.UserLive.Edit do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Accounts
  alias EcommerceLiveWeb.Admin.UserLive.FormComponent

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Edit User")
     |> assign(:user, user)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <h1 class="text-2xl font-bold mb-4">Edit User</h1>

      <.live_component
        module={FormComponent}
        id="edit-user"
        user={@user}
        action={:edit}
        navigate={~p"/admin/users"}
      />
    </div>
    """
  end
end
