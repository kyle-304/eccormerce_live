defmodule EcommerceLive.Payments do
  @moduledoc """
  The Payments context.

  Handles payment creation, updates, and retrieval.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Payments.Payment

  # ------------------------------------
  # PAYMENTS CRUD
  # ------------------------------------

  @doc """
  Lists all payments.

  Returns a list of all payments in the system.

  ## Examples

      iex> list_payments()
      [%Payment{}, %Payment{}]
  """
  def list_payments do
    Repo.all(Payment)
  end

  @doc """
  Gets a payment by its ID.

  Raises `Ecto.NoResultsError` if the payment is not found.

  ## Examples

      iex> get_payment!(123)
      %Payment{id: 123}

      iex> get_payment!(999)
      ** (Ecto.NoResultsError)
  """
  def get_payment!(id), do: Repo.get!(Payment, id)

  @doc """
  Creates a new payment with the given attributes.

  Returns `{:ok, %Payment{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> create_payment(%{amount: 100, method: "credit_card"})
      {:ok, %Payment{}}

      iex> create_payment(%{amount: -10, method: "paypal"})
      {:error, %Ecto.Changeset{}}
  """
  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment with the given attributes.

  Returns `{:ok, %Payment{}}` on success or `{:error, %Ecto.Changeset{}}` if validation fails.

  ## Examples

      iex> update_payment(payment, %{status: "completed"})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{amount: -10})
      {:error, %Ecto.Changeset{}}
  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the given payment.

  Returns `{:ok, %Payment{}}` on success or `{:error, %Ecto.Changeset{}}` if there is an issue with deletion.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}
  """
  def delete_payment(%Payment{} = payment), do: Repo.delete(payment)

  @doc """
  Returns a changeset for modifying the given payment.

  ## Examples

      iex> change_payment(payment, %{status: "pending"})
      %Ecto.Changeset{}
  """
  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  # ------------------------------
  # UTILITIES
  # ------------------------------

  @doc """
  Lists all payments related to a specific order.

  Returns a list of payments for the given order ID.

  ## Examples

      iex> list_payments_for_order(order_id)
      [%Payment{}, %Payment{}]
  """
  def list_payments_for_order(order_id) do
    Payment
    |> where(order_id: ^order_id)
    |> Repo.all()
  end
end
