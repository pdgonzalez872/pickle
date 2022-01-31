# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pickle.Repo.insert!(%Pickle.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
state =
  [File.cwd!(), "scrappable_html", "pickleball_tournaments_2022.html"]
  |> Path.join()
  |> Pickle.UsaPickleballParser.call()

state.tournaments
|> Enum.each(fn tournament ->
  Pickle.Events.create_tournaments(tournament) |> IO.inspect()
end)
