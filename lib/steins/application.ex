defmodule Steins.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: SteinsWeb.Endpoint, options: [port: Application.get_env(:steins, :port, 4000)]}
    ]

    opts = [strategy: :one_for_one, name: Steins.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
