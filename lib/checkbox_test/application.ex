defmodule CheckboxTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      CheckboxTestWeb.Telemetry,
      # Start the Ecto repository
      CheckboxTest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: CheckboxTest.PubSub},
      # Start Finch
      {Finch, name: CheckboxTest.Finch},
      # Start the Endpoint (http/https)
      CheckboxTestWeb.Endpoint
      # Start a worker by calling: CheckboxTest.Worker.start_link(arg)
      # {CheckboxTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CheckboxTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CheckboxTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
