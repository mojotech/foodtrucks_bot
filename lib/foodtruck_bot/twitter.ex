defmodule FoodtruckBot.Twitter do

  alias FoodtruckBot.TweetFilter
  alias ExTwitter.API.Timelines

  import Slack.Sends, only: [send_message: 3]

  @trucks Application.get_env(:foodtruck_bot, __MODULE__)[:trucks]

  @spec fetch_trucks(String.t, %Slack.State{}) :: {:ok}
  def fetch_trucks(message, slack) do
    stream = Task.Supervisor.async_stream(FoodtruckBot.TaskSupervisor, @trucks, __MODULE__, :fetch_truck, [message])

    stream
    |> Enum.to_list
    |> Enum.filter(&truck_out_today/1)
    |> Keyword.values()
    |> send_completion_message(message, slack)
  end

  def fetch_truck(truck, %{channel: channel}) do
    tweets = Timelines.user_timeline(timeline_options(truck))

    tweets
    |> TweetFilter.todays_location
    |> tweet_status_url
  end

  defp send_completion_message([], %{channel: channel, user: user}, slack) do
    msg = "<@#{user}> No trucks today... Or at least they aren't using the Twitters.  Maybe just look out the window instead?"
    msg |> send_message(channel, slack)
  end
  defp send_completion_message(tweets, %{channel: channel}, slack) do
    tweets |> Enum.each(&(Slack.Sends.send_message(&1, channel, slack)))
  end

  defp truck_out_today({:ok, :no_tweet}), do: false
  defp truck_out_today({:ok, _url}), do: true

  defp tweet_status_url(nil), do: :no_tweet
  defp tweet_status_url(tweet) do
    "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id_str}"
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
