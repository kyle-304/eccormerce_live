defmodule EcommerceLiveWeb.Admin.ReviewLive.Index do
  use EcommerceLiveWeb, :live_view

  alias EcommerceLive.Reviews

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, reviews: Reviews.list_reviews())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Reviews.get_review!(id)
    {:ok, _} = Reviews.delete_review(review)
    {:noreply, assign(socket, reviews: Reviews.list_reviews())}
  end
end
