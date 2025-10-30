defmodule EcommerceLive.Reviews do
  @moduledoc """
  The Reviews context.

  Handles product reviews written by users, including creation, listing,
  and calculating average ratings per product.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Reviews.Review

  # ----------------------------------------------------------------
  # REVIEWS CRUD
  # ----------------------------------------------------------------

  @spec list_reviews() :: [Review.t()]
  def list_reviews do
    Repo.all(Review)
  end

  @spec get_review!(Ecto.UUID.t()) :: Review.t()
  def get_review!(id), do: Repo.get!(Review, id)

  @spec create_review(map()) :: {:ok, Review.t()} | {:error, Ecto.Changeset.t()}
  def create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_review(Review.t(), map()) :: {:ok, Review.t()} | {:error, Ecto.Changeset.t()}
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_review(Review.t()) :: {:ok, Review.t()} | {:error, Ecto.Changeset.t()}
  def delete_review(%Review{} = review), do: Repo.delete(review)

  @spec change_review(Review.t(), map()) :: Ecto.Changeset.t()
  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  # ----------------------------------------------------------------
  # QUERIES & UTILITIES
  # ----------------------------------------------------------------

  @doc """
  Lists all reviews for a specific product, ordered by creation date (newest first).
  """
  @spec list_reviews_for_product(Ecto.UUID.t()) :: [Review.t()]
  def list_reviews_for_product(product_id) do
    Review
    |> where(product_id: ^product_id)
    |> order_by([r], desc: r.inserted_at)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Lists all reviews written by a specific user.
  """
  @spec list_reviews_by_user(Ecto.UUID.t()) :: [Review.t()]
  def list_reviews_by_user(user_id) do
    Review
    |> where(user_id: ^user_id)
    |> preload(:product)
    |> Repo.all()
  end

  @doc """
  Calculates the average rating for a specific product.
  Returns `Decimal` or `0` if no reviews exist.
  """
  @spec average_rating_for_product(Ecto.UUID.t()) :: Decimal.t()
  def average_rating_for_product(product_id) do
    result =
      Review
      |> where(product_id: ^product_id)
      |> select([r], avg(r.rating))
      |> Repo.one()

    result || Decimal.new(0)
  end

  @doc """
  Checks if a user has already reviewed a product.
  """
  @spec user_reviewed_product?(Ecto.UUID.t(), Ecto.UUID.t()) :: boolean()
  def user_reviewed_product?(user_id, product_id) do
    Review
    |> where(user_id: ^user_id, product_id: ^product_id)
    |> Repo.exists?()
  end
end
