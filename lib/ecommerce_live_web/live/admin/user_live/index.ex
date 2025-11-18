defmodule EcommerceLiveWeb.Admin.UserLive.Index do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Accounts
  alias EcommerceLive.Accounts.User

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:users, list_users())
     |> assign(:term, "")}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("search", %{"term" => term}, socket) do
    term = String.trim(term || "")

    users =
      if term == "" do
        Accounts.list_users()
      else
        Accounts.search_users(term)
      end

    {:noreply, assign(socket, users: users, term: term)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)
    {:noreply, assign(socket, :users, list_users())}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
    |> assign(:action, :edit)
    |> assign(:navigate, ~p"/admin/users")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
    |> assign(:action, :new)
    |> assign(:navigate, ~p"/admin/users")
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Users")
    |> assign(:user, nil)
    |> assign(:action, :index)
  end

  defp list_users do
    Accounts.list_users()
  end
end
