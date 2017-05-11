defmodule FoodtruckBot.Database do

  require Postgrex

  def query(statement, opts) do
    db_creds = Application.get_env(:foodtruck_bot, FoodtruckBot.Database)

    request = Task.async(fn ->
      {_, pid} = Postgrex.start_link(db_creds)
      Postgrex.query!(pid, statement, opts)
    end)

    Task.await(request)
  end

  def query(statement) do
    query(statement, [])
  end
end
