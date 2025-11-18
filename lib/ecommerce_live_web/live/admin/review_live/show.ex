defmodule EcommerceLiveWeb.Admin.ReviewLive.Show do
  use EcommerceLiveWeb, :live_view
  
  alias EcommerceLive.Reviews
  alias EcommerceLive.Reviews.Review

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    review = Reviews.get_review!(id)
    {:ok, assign(socket, review: review, changeset: Reviews.change_review(review))}
  end

  @impl true
  def handle_event("save", %{"review" => attrs}, socket) do
    case Reviews.update_review(socket.assigns.review, attrs) do
      {:ok, review} ->
        {:noreply, assign(socket, review: review, changeset: Reviews.change_review(review))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
