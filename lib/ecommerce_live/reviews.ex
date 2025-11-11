defmodule EcommerceLive.Reviews do
  @moduledoc """
  The Reviews context.

  Handles product reviews written by users, including creation, listing,
  and calculating average ratings per product.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Reviews.Review

  # ---------------
  # REVIEWS CRUD
  # ---------------

  @doc """
  Lists all reviews.

  Returns a list of all reviews in the system.

  ## Examples

      iex> list_reviews()
      [%Review{}, %Review{}]
  """
  def list_reviews do
    Repo.all(Review)
  end

  @doc """
  Gets a review by its ID.

  Raises `Ecto.NoResultsError` if the review is not found.

  ## Examples

      iex> get_review!(123)
      %Review{id: 123}

      iex> get_review!(999)
      ** (Ecto.NoResultsError)
  """
  def get_review!(id), do: Repo.get!(Review, id)

  @doc """
  Creates a new review with the given attributes.

  Returns `{:ok, %Review{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_review(%{rating: 5, comment: "Great product!"})
      {:ok, %Review{}}

      iex> create_review(%{rating: 6, comment: "Invalid rating"})
      {:error, %Ecto.Changeset{}}
  """
  def create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review with the given attributes.

  Returns `{:ok, %Review{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> update_review(review, %{comment: "Updated comment"})
      {:ok, %Review{}}

      iex> update_review(review, %{rating: 10})
      {:error, %Ecto.Changeset{}}
  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the given review.

  Returns `{:ok, %Review{}}` on success or `{:error, %Ecto.Changeset{}}` if there is an issue with deletion.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}
  """
  def delete_review(%Review{} = review), do: Repo.delete(review)

  @doc """
  Returns a changeset for modifying the given review.

  ## Examples

      iex> change_review(review, %{comment: "Updated comment"})
      %Ecto.Changeset{}
  """
  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  # --------------------
  # QUERIES & UTILITIES
  # --------------------

  @doc """
  Lists all reviews for a specific product, ordered by creation date (newest first).

  ## Examples

      iex> list_reviews_for_product(product_id)
      [%Review{}, %Review{}]
  """
  def list_reviews_for_product(product_id) do
    Review
    |> where(product_id: ^product_id)
    |> order_by([r], desc: r.inserted_at)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Lists all reviews written by a specific user.

  ## Examples

      iex> list_reviews_by_user(user_id)
      [%Review{}, %Review{}]
  """
  def list_reviews_by_user(user_id) do
    Review
    |> where(user_id: ^user_id)
    |> preload(:product)
    |> Repo.all()
  end

  @doc """
  Calculates the average rating for a specific product.

  Returns `Decimal` or `0` if no reviews exist for the product.

  ## Examples

      iex> average_rating_for_product(product_id)
      #Decimal<4.5>
  """
  def average_rating_for_product(product_id) do
    result =
      Review
      |> where(product_id: ^product_id)
      |> select([r], avg(r.rating))
      |> Repo.one()

    result || Decimal.new(0)
  end

  @doc """
  Checks if a user has already reviewed a specific product.

  Returns `true` if the user has reviewed the product, `false` otherwise.

  ## Examples

      iex> user_reviewed_product?(user_id, product_id)
      true

      iex> user_reviewed_product?(user_id, non_reviewed_product_id)
      false
  """
  def user_reviewed_product?(user_id, product_id) do
    Review
    |> where(user_id: ^user_id, product_id: ^product_id)
    |> Repo.exists?()
  end
end
