defmodule Pickle.EventsTest do
  use Pickle.DataCase

  alias Pickle.Events

  describe "tournaments" do
    alias Pickle.Events.Tournaments

    import Pickle.EventsFixtures

    @invalid_attrs %{
      address: nil,
      city: nil,
      end_date: nil,
      map_link: nil,
      name: nil,
      organizer: nil,
      prize_money: nil,
      start_date: nil,
      state: nil,
      url: nil,
      zip: nil
    }

    test "list_tournaments/0 returns all tournaments" do
      tournaments = tournaments_fixture()
      assert Events.list_tournaments() == [tournaments]
    end

    test "get_tournaments!/1 returns the tournaments with given id" do
      tournaments = tournaments_fixture()
      assert Events.get_tournaments!(tournaments.id) == tournaments
    end

    test "create_tournaments/1 with valid data creates a tournaments" do
      valid_attrs = %{
        address: "some address",
        city: "some city",
        end_date: ~N[2022-01-30 04:21:00],
        map_link: "some map_link",
        name: "some name",
        organizer: "some organizer",
        prize_money: 42,
        start_date: ~N[2022-01-30 04:21:00],
        state: "some state",
        url: "some url",
        zip: "some zip"
      }

      assert {:ok, %Tournaments{} = tournaments} = Events.create_tournaments(valid_attrs)
      assert tournaments.address == "some address"
      assert tournaments.city == "some city"
      assert tournaments.end_date == ~N[2022-01-30 04:21:00]
      assert tournaments.map_link == "some map_link"
      assert tournaments.name == "some name"
      assert tournaments.organizer == "some organizer"
      assert tournaments.prize_money == 42
      assert tournaments.start_date == ~N[2022-01-30 04:21:00]
      assert tournaments.state == "some state"
      assert tournaments.url == "some url"
      assert tournaments.zip == "some zip"
    end

    test "create_tournaments/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_tournaments(@invalid_attrs)
    end

    test "update_tournaments/2 with valid data updates the tournaments" do
      tournaments = tournaments_fixture()

      update_attrs = %{
        address: "some updated address",
        city: "some updated city",
        end_date: ~N[2022-01-31 04:21:00],
        map_link: "some updated map_link",
        name: "some updated name",
        organizer: "some updated organizer",
        prize_money: 43,
        start_date: ~N[2022-01-31 04:21:00],
        state: "some updated state",
        url: "some updated url",
        zip: "some updated zip"
      }

      assert {:ok, %Tournaments{} = tournaments} =
               Events.update_tournaments(tournaments, update_attrs)

      assert tournaments.address == "some updated address"
      assert tournaments.city == "some updated city"
      assert tournaments.end_date == ~N[2022-01-31 04:21:00]
      assert tournaments.map_link == "some updated map_link"
      assert tournaments.name == "some updated name"
      assert tournaments.organizer == "some updated organizer"
      assert tournaments.prize_money == 43
      assert tournaments.start_date == ~N[2022-01-31 04:21:00]
      assert tournaments.state == "some updated state"
      assert tournaments.url == "some updated url"
      assert tournaments.zip == "some updated zip"
    end

    test "update_tournaments/2 with invalid data returns error changeset" do
      tournaments = tournaments_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_tournaments(tournaments, @invalid_attrs)
      assert tournaments == Events.get_tournaments!(tournaments.id)
    end

    test "delete_tournaments/1 deletes the tournaments" do
      tournaments = tournaments_fixture()
      assert {:ok, %Tournaments{}} = Events.delete_tournaments(tournaments)
      assert_raise Ecto.NoResultsError, fn -> Events.get_tournaments!(tournaments.id) end
    end

    test "change_tournaments/1 returns a tournaments changeset" do
      tournaments = tournaments_fixture()
      assert %Ecto.Changeset{} = Events.change_tournaments(tournaments)
    end
  end
end
