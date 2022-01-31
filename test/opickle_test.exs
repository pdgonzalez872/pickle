defmodule PickleTest do
  use ExUnit.Case

  describe "Scrapes the tournaments correctly" do
    test "works" do
      state =
        [File.cwd!(), "test", "scrappable_html", "pickleball_tournaments_2022.html"]
        |> Path.join()
        |> Pickle.UsaPickleballParser.call()

      assert Enum.count(state.tournaments) == 117

      start_date = Date.new!(2022, 12, 2)
      end_date = Date.new!(2022, 12, 4)

      assert %{
               address: "77333 Country Club Dr",
               city: "Palm Desert",
               end_date: ^end_date,
               name: "NP Palm Desert Open",
               prize_money: "$0",
               start_date: ^start_date,
               state: "CA",
               url: "https://usapickleball.org/event/np-palm-desert-open/",
               zip: "92211",
               map_link:
                 "https://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=77333+Country+Club+Dr+Palm+Desert+CA+92211+United+States",
               organizer: :usa_pickleball
             } = Enum.at(state.tournaments, -1)
    end
  end
end
