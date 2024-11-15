defmodule TakeHome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TakeHomeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:take_home, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TakeHome.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TakeHome.Finch},
      # Start a worker by calling: TakeHome.Worker.start_link(arg)
      # {TakeHome.Worker, arg},
      # Start to serve requests, typically the last entry
      TakeHomeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TakeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TakeHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
