defmodule EcommerceLive.Repo do
  use Ecto.Repo,
    otp_app: :ecommerce_live,
    adapter: Ecto.Adapters.Postgres
end
