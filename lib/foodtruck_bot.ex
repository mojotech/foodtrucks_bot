defmodule FoodtruckBot do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:foodtruck_bot, FoodtruckBot.Slack)[:token]

    children = [
      # Define workers and child supervisors to be supervised
      # worker(FoodtruckBot.Worker, [arg1, arg2, arg3]),
      supervisor(Task.Supervisor, [[name: FoodtruckBot.TaskSupervisor]]),
      worker(FoodtruckBot.Slack, [slack_token])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodtruckBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
