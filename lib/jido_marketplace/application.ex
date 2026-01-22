defmodule JidoMarketplace.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JidoMarketplaceWeb.Telemetry,
      JidoMarketplace.Repo,
      {DNSCluster, query: Application.get_env(:jido_marketplace, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JidoMarketplace.PubSub},
      JidoMarketplace.Jido,
      # Start a worker by calling: JidoMarketplace.Worker.start_link(arg)
      # {JidoMarketplace.Worker, arg},
      # Start to serve requests, typically the last entry
      JidoMarketplaceWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :jido_marketplace]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JidoMarketplace.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JidoMarketplaceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
