defmodule FoodtruckBot.Twitter do
  # use ExTwitter.API.Timelines

  def fetch_trucks(channel, slack) do
    Application.get_env(:foodtruck_bot, FoodtruckBot.Twitter)[:trucks]
    |> fetch_trucks(channel, slack)
  end

  def fetch_trucks([truck | t], channel, slack) do
    ExTwitter.API.Timelines.user_timeline(timeline_options(truck))
    |> List.first
    |> send_tweet(channel, slack)

    fetch_trucks(t, channel, slack)
  end
  def fetch_trucks([], _channel, _slack), do: {:ok}

  defp send_tweet(tweet, channel, slack) do
    tweet_status_url(tweet) |> Slack.Sends.send_message(channel, slack)
  end

  @spec tweet_status_url(ExTwitter.Model.Tweet) :: String.t
  defp tweet_status_url(tweet) do
    "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
  end

  defp timeline_options(screen_name) do
    [
      screen_name: screen_name,
      count: 10,
      exclude_replies: true, # don't need reply tweets
      include_rts: false     # don't need native retweets
    ]
  end
end
