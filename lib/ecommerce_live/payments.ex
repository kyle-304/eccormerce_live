defmodule EcommerceLive.Payments do
  @moduledoc """
  The Payments context.

  Handles payment creation, updates, and retrieval.
  """

  import Ecto.Query, warn: false
  alias EcommerceLive.Repo
  alias EcommerceLive.Payments.Payment

  # ----------------------------------------------------------------
  # PAYMENTS CRUD
  # ----------------------------------------------------------------

  @spec list_payments() :: [Payment.t()]
  def list_payments do
    Repo.all(Payment)
  end

  @spec get_payment!(Ecto.UUID.t()) :: Payment.t()
  def get_payment!(id), do: Repo.get!(Payment, id)

  @spec create_payment(map()) :: {:ok, Payment.t()} | {:error, Ecto.Changeset.t()}
  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_payment(Payment.t(), map()) :: {:ok, Payment.t()} | {:error, Ecto.Changeset.t()}
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_payment(Payment.t()) :: {:ok, Payment.t()} | {:error, Ecto.Changeset.t()}
  def delete_payment(%Payment{} = payment), do: Repo.delete(payment)

  @spec change_payment(Payment.t(), map()) :: Ecto.Changeset.t()
  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end

  # ----------------------------------------------------------------
  # UTILITIES
  # ----------------------------------------------------------------

  @doc """
  Lists all payments related to a specific order.
  """
  @spec list_payments_for_order(Ecto.UUID.t()) :: [Payment.t()]
  def list_payments_for_order(order_id) do
    Payment
    |> where(order_id: ^order_id)
    |> Repo.all()
  end
end
