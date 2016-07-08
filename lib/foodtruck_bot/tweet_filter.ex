defmodule FoodtruckBot.TweetFilter do
  @twitter_date_format "{WDshort} {Mshort} {D} {h24}:{m}:{s} {Z} {YYYY}"

  @doc """
  Finds the first tweet that gives the location of a food truck today
  """

  @spec todays_location([ExTwitter.Model.Tweet]) :: ExTwitter.Model.Tweet
  def todays_location([]), do: nil
  def todays_location([tweet | rest]) do
    cond do
      useful_info(tweet) -> tweet
      true -> todays_location(rest)
    end
  end

  @spec useful_info(ExTwitter.Model.Tweet) :: boolean()
  defp useful_info(tweet) do
    cond do
      from_today(tweet) -> about_kennedy_plaza?(tweet.text)
      true -> false
    end
  end

  @spec from_today(ExTwitter.Model.Tweet) :: boolean()
  defp from_today(tweet) do
    {:ok, parsed} = Timex.parse(tweet.created_at, @twitter_date_format)
    today = Timex.DateTime.today
    {parsed.year, parsed.month, parsed.day} == {today.year, today.month, today.day}
  end

  @spec about_kennedy_plaza?(ExTwitter.Model.Tweet) :: boolean()
  defp about_kennedy_plaza?(text) do
    Regex.match? ~r/kp|kennedy|burnside/i, text
  end
end
