defmodule EcommerceLive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EcommerceLiveWeb.Telemetry,
      EcommerceLive.Repo,
      {DNSCluster, query: Application.get_env(:ecommerce_live, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: EcommerceLive.PubSub},
      # Start a worker by calling: EcommerceLive.Worker.start_link(arg)
      # {EcommerceLive.Worker, arg},
      # Start to serve requests, typically the last entry
      EcommerceLiveWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EcommerceLive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EcommerceLiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
