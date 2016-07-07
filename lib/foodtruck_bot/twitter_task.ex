defmodule FoodtruckBot.Twitter do
  def fetch_trucks(channel, slack) do
    Slack.Sends.send_message("* FETCHING TWITTER FEEDS FOR TRUCKS *", channel, slack)
  end
end
