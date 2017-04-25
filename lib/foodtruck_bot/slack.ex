defmodule FoodtruckBot.Slack do
  use Slack

  def handle_event(message = %{type: "message"}, slack, state) do
    if Map.has_key?(message, :text) do
      parse_message(message, slack, state)
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  defp parse_message(message, slack, state) do
    if Regex.run ~r/<@#{slack.me.id}>:?\s+.*today.*/, message.text do
      Task.start fn() -> FoodtruckBot.Twitter.fetch_trucks(message, slack) end
      send_message("Checking today's trucks...", message.channel, slack) 
    end
  end
end
