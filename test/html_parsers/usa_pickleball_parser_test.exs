defmodule PickleTest do
  use ExUnit.Case

  describe "Scrapes the tournaments correctly" do
    test "works" do
      tournaments =
        [File.cwd!(), "scrappable_html", "usa_pickleball_schedule.html"]
        |> Path.join()
        |> File.read!()
        |> Pickle.UsaPickleballParser.call()

      assert Enum.count(tournaments) == 117

      assert %{
               address: "2343 E Tournament Way",
               city: "Tucson",
               end_date: end_date,
               map_link:
                 "https://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=2343+E+Tournament+Way+Tucson+AZ+85713+United+States",
               name: "2022 Tucson Senior Olympic Festival",
               organizer: "usa_pickleball",
               prize_money: 0,
               start_date: start_date,
               state: "AZ",
               url: "https://usapickleball.org/event/2022-tucson-senior-olympic-festival/",
               zip: "85713"
             } = Enum.at(tournaments, 0)

      assert start_date.year == 2022
      assert start_date.month == 1
      assert start_date.day == 26

      assert end_date.year == 2022
      assert end_date.month == 1
      assert end_date.day == 30

      assert %{
               address: "77333 Country Club Dr",
               city: "Palm Desert",
               end_date: end_date,
               name: "NP Palm Desert Open",
               prize_money: 0,
               start_date: start_date,
               state: "CA",
               url: "https://usapickleball.org/event/np-palm-desert-open/",
               zip: "92211",
               map_link:
                 "https://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=77333+Country+Club+Dr+Palm+Desert+CA+92211+United+States",
               organizer: "usa_pickleball"
             } = Enum.at(tournaments, -1)

      assert start_date.year == 2022
      assert start_date.month == 12
      assert start_date.day == 2

      assert end_date.year == 2022
      assert end_date.month == 12
      assert end_date.day == 4
    end
  end
end
