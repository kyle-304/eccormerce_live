defmodule EcommerceLiveWeb.Admin.UserLive.Show do
  use EcommerceLiveWeb, :live_view
  alias EcommerceLive.Accounts

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:page_title, "User Details")
     |> assign(:user, user)}
  end

  def render(assigns) do
    ~H"""
    <div class="p-6 space-y-6">
      <div class="flex justify-between items-center">
        <h1 class="text-2xl font-bold">{@user.email}</h1>
        <.link
          patch={~p"/admin/users/#{@user.id}/edit"}
          class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
        >
          Edit
        </.link>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="space-y-2">
          <p><strong>Email:</strong> {@user.email}</p>
          <p><strong>Role:</strong> {@user.role || "User"}</p>
          <p><strong>Phone:</strong> {@user.phone || "—"}</p>
          <p><strong>Confirmed At:</strong> {@user.confirmed_at || "Not confirmed"}</p>
          <%!-- <p><strong>Inserted At:</strong> <%= @user.inserted_at |> Timex.format!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}") %></p> --%>
          <%!-- <p><strong>Updated At:</strong> <%= @user.updated_at |> Timex.format!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}") %></p> --%>
        </div>
      </div>

      <div>
        <.link
          navigate={~p"/admin/users"}
          class="px-4 py-2 bg-gray-100 rounded-lg hover:bg-gray-200"
        >
          ← Back to Users
        </.link>
      </div>
    </div>
    """
  end
end
