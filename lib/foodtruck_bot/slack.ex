defmodule FoodtruckBot.Slack do
  use Slack

  def handle_event(%{type: "message"} = message, slack, state) do
    if Map.has_key?(message, :text) do
      parse_message(message, slack)
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  defp parse_message(message, slack) do
    if Regex.run ~r/<@#{slack.me.id}>:?\s+.*today.*/, message.text do
      send_message("Checking today's trucks...", message.channel, slack)
      Task.start fn() -> FoodtruckBot.Twitter.fetch_trucks(message, slack) end
    end

    if Regex.run ~r/<@#{slack.me.id}>:?\s+.*watch.*/, message.text do
      twitter_regex = ~r/(?<=^|(?<=[^a-zA-Z0-9-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/
      truck_handle = Regex.scan(twitter_regex, message.text) |> List.last |> List.first

      Task.start fn -> FoodtruckBot.Trucks.watch(truck_handle, message, slack) end
    end
  end
end
