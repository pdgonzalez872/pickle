defmodule Pickle.APPParserTest do
  use ExUnit.Case

  describe "Scrapes the tournaments correctly" do
    test "works" do
      state =
        [File.cwd!(), "scrappable_html", "app_schedule.html"]
        |> Path.join()
        |> Pickle.APPParser.call()

      assert Enum.count(state.tournaments) == 34

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
             } = Enum.at(state.tournaments, -1)

      assert start_date.year == 2022
      assert start_date.month == 12
      assert start_date.day == 2

      assert end_date.year == 2022
      assert end_date.month == 12
      assert end_date.day == 4
    end
  end
end
