defmodule Pickle.PPAParserTest do
  use ExUnit.Case

  describe "Scrapes the tournaments correctly - PPA" do
    test "works" do
      tournaments =
        [File.cwd!(), "scrappable_html", "ppa_schedule.html"]
        |> Path.join()
        |> File.read!()
        |> Pickle.PPAParser.call()

      assert Enum.count(tournaments) == 19

      assert %{
              address: "5350 E Marriott Dr",
              city: "Phoenix",
              end_date: end_date,
              name: "Carvana Desert Ridge Open",
              organizer: "ppa",
              prize_money: 120,
              start_date: start_date,
              url: "https://www.ppatour.com/event-location/jw-marriott-phoenix-desert-ridge-resort-spa/",
              state: "AZ"
            } = Enum.at(tournaments, 0)

      assert start_date.year == 2022
      assert start_date.month == 1
      assert start_date.day == 25

      assert end_date.year == 2022
      assert end_date.month == 1
      assert end_date.day == 30

      assert %{
        end_date: end_date,
        name: "The Hyundai Masters (Grand Slam)",
        organizer: "ppa",
        prize_money: 120,
        start_date: start_date,
        address: nil,
        url: nil
      } = Enum.at(tournaments, -1)

      assert start_date.year == 2022
      assert start_date.month == 12
      assert start_date.day == 15

      assert end_date.year == 2022
      assert end_date.month == 12
      assert end_date.day == 18
    end
  end
end
