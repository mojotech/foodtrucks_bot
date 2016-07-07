defmodule FoodtruckBot.TweetFilter do
  @doc """
  Finds the first tweet that gives the location of a food truck today
  """

  @spec todays_location([ExTwitter.Model.Tweet]) :: ExTwitter.Model.Tweet
  def todays_location([]), do: nil
  def todays_location([tweet | rest]) do
    cond do
      useful_info(tweet.text) -> tweet
      true -> todays_location(rest)
    end
  end

  @doc """
  Determines if a tweet's content places the location of a truck in Kennedy
  Plaze for the current day.
  """

  @spec useful_info(ExTwitter.Model.Tweet) :: bool()
  defp useful_info(tweet), do: true

end
