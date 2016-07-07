defmodule FoodtruckBot.Slack do
  use Slack

  def handle_message(message = %{type: "message"}, slack) do
    Logger.debug "MESSAGE: #{inspect message}\nME ID: #{slack.me.id}"
    if Regex.run ~r/<@#{slack.me.id}>:?\s+.*today.*/, message.text do
      {:ok, _pid} = Task.Supervisor.start_child(FoodtruckBot.TaskSupervisor, fn -> FoodtruckBot.Twitter.fetch_trucks(message.channel, slack) end)
      send_message("Checking today's trucks...", message.channel, slack)
    end

    {:ok}
  end
  def handle_message(_, _), do: {:ok}
end
