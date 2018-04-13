defmodule FoodtruckBot.Trucks do

  alias FoodtruckBot.Database

  import Slack.Sends, only: [send_message: 3]

  def all do
    Database.query("SELECT * FROM trucks").rows
  end

  def find_by_handle(handle) do
    Database.query("SELECT * FROM trucks WHERE handle = $1", [handle]).rows
  end

  def create(handle) do
    Database.query("INSERT INTO trucks (handle) VALUES ($1)", [handle])
  end

  def watch(handle, message, slack) do
    if Enum.any?(find_by_handle(handle)) do
      create(handle)
      send_message("I'll keep an eye on that truck for you!", message.channel, slack)
    else
      send_message("One step ahead of you... I'm already tracking that truck.", message.channel, slack)
    end
  end

  def seed() do
    trucks = [
      "@pocolocotacos",
      "@mijostacos",
      "@rockettruck",
      "@NobleKnots",
      "@MamaKimsKbbq",
      "@PORTU_GALO",
      "@ocreperi",
      "@soulfullri",
      "@Citizenwings",
      "@gastros401",
      "@soulfullri",
      "@redskitchn",
      "@igottaq",
      "@openseasontruck",
      "@bonme",
      "@bowledflavor"
    ]

    Enum.each trucks, fn(t) -> create(t) end
  end
end
