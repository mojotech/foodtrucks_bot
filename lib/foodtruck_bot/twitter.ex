defmodule FoodtruckBot.Twitter do

  @spec fetch_trucks(String.t, %Slack.State{}) :: {:ok}
  def fetch_trucks(channel, slack) do
    Application.get_env(:foodtruck_bot, FoodtruckBot.Twitter)[:trucks]
    |> fetch_trucks(channel, slack)
  end

  @spec fetch_trucks([String.t], String.t, %Slack.State{}) :: {:ok}
  def fetch_trucks([truck | t], channel, slack) do
    ExTwitter.API.Timelines.user_timeline(timeline_options(truck))
    |> FoodtruckBot.TweetFilter.todays_location
    |> send_tweet(channel, slack)

    fetch_trucks(t, channel, slack)
  end
  def fetch_trucks([], _channel, _slack), do: {:ok}

  @spec send_tweet(ExTwitter.Model.Tweet, String.t, String.t) :: any
  @spec send_tweet(none(), String.t, %Slack.State{}) :: {:ok}
  defp send_tweet(nil, _channel, _slack), do: {:ok}
  defp send_tweet(tweet, channel, slack) do
    tweet_status_url(tweet) |> Slack.Sends.send_message(channel, slack)
  end

  @spec tweet_status_url(ExTwitter.Model.Tweet) :: String.t
  defp tweet_status_url(tweet) do
    "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
  end

  @spec timeline_options(String.t) :: [screen_name: String.t, count: pos_integer(), exclude_replies: boolean(), include_rts: boolean()]
  defp timeline_options(screen_name) do
    [
      screen_name: screen_name,
      count: 10,
      exclude_replies: true, # don't need reply tweets
      include_rts: false     # don't need native retweets
    ]
  end
end
