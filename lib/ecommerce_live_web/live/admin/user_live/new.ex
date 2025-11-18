defmodule EcommerceLiveWeb.Admin.UserLive.New do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "New User")
     |> assign(:user, %User{})
     |> assign(:action, :new)
     |> assign(:navigate, ~p"/admin/users")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto">
      <h1 class="text-2xl font-bold mb-6">New User</h1>

      <.live_component
        module={EcommerceLiveWeb.Admin.UserLive.FormComponent}
        id="new-user"
        user={@user}
        action={@action}
        navigate={@navigate}
      />
    </div>
    """
  end
end
