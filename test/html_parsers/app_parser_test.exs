defmodule Pickle.APPParserTest do
  use ExUnit.Case

  describe "Scrapes the tournaments correctly - APP" do
    test "works" do
      tournaments =
        [File.cwd!(), "scrappable_html", "app_schedule.html"]
        |> Path.join()
        |> File.read!()
        |> Pickle.APPParser.call()

      assert Enum.count(tournaments) == 34

      assert %{
               city: "Mesa",
               dates: "JAN 13 - 16, 2022",
               end_date: end_date,
               name: "Mesa Open",
               organizer: "app",
               prize_money: 75,
               start_date: start_date,
               state: "AZ"
             } = Enum.at(tournaments, 0)

      assert start_date.year == 2022
      assert start_date.month == 1
      assert start_date.day == 13

      assert end_date.year == 2022
      assert end_date.month == 1
      assert end_date.day == 16

      assert %{
               city: "Unknown",
               dates: "JAN 2023",
               name: "APP Masters",
               organizer: "app",
               prize_money: 75,
               state: "FL",
               end_date: nil,
               start_date: start_date
             } = Enum.at(tournaments, -1)

      assert start_date.year == 2023
      assert start_date.month == 1
      assert start_date.day == 1
    end
  end
end
