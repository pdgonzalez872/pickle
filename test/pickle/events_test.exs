defmodule Pickle.EventsTest do
  use Pickle.DataCase

  alias Pickle.Events

  describe "tournament" do
    alias Pickle.Events.Tournament

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
      tournament = tournaments_fixture()
      assert Events.list_tournaments() == [tournament]
    end

    test "get_tournament!/1 returns the tournament with given id" do
      tournament = tournaments_fixture()
      assert Events.get_tournament!(tournament.id) == tournament
    end

    test "create_tournament/1 with valid data creates a tournament" do
      valid_attrs = %{
        address: "some address",
        city: "some city",
        end_date: ~U[2022-01-30 04:21:00Z],
        map_link: "some map_link",
        name: "some name",
        organizer: "some organizer",
        prize_money: 42,
        start_date: ~N[2022-01-30 04:21:00],
        state: "some state",
        url: "some url",
        zip: "some zip"
      }

      assert {:ok, %Tournament{} = tournament} = Events.create_tournament(valid_attrs)
      assert tournament.address == "some address"
      assert tournament.city == "some city"
      assert tournament.end_date == ~U[2022-01-30 04:21:00Z]
      assert tournament.map_link == "some map_link"
      assert tournament.name == "some name"
      assert tournament.organizer == "some organizer"
      assert tournament.prize_money == 42
      assert tournament.start_date == ~U[2022-01-30 04:21:00Z]
      assert tournament.state == "some state"
      assert tournament.url == "some url"
      assert tournament.zip == "some zip"
    end

    test "create_tournament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_tournament(@invalid_attrs)
    end

    test "update_tournament/2 with valid data updates the tournament" do
      tournament = tournaments_fixture()

      update_attrs = %{
        address: "some updated address",
        city: "some updated city",
        end_date: ~U[2022-01-31 04:21:00Z],
        map_link: "some updated map_link",
        name: "some updated name",
        organizer: "some updated organizer",
        prize_money: 43,
        start_date: ~U[2022-01-31 04:21:00Z],
        state: "some updated state",
        url: "some updated url",
        zip: "some updated zip"
      }

      assert {:ok, %Tournament{} = tournament} =
               Events.update_tournament(tournament, update_attrs)

      assert tournament.address == "some updated address"
      assert tournament.city == "some updated city"
      assert tournament.end_date == ~U[2022-01-31 04:21:00Z]
      assert tournament.map_link == "some updated map_link"
      assert tournament.name == "some updated name"
      assert tournament.organizer == "some updated organizer"
      assert tournament.prize_money == 43
      assert tournament.start_date == ~U[2022-01-31 04:21:00Z]
      assert tournament.state == "some updated state"
      assert tournament.url == "some updated url"
      assert tournament.zip == "some updated zip"
    end

    test "update_tournament/2 with invalid data returns error changeset" do
      tournament = tournaments_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_tournament(tournament, @invalid_attrs)
      assert tournament == Events.get_tournament!(tournament.id)
    end

    test "delete_tournaments/1 deletes the tournament" do
      tournament = tournaments_fixture()
      assert {:ok, %Tournament{}} = Events.delete_tournaments(tournament)
      assert_raise Ecto.NoResultsError, fn -> Events.get_tournament!(tournament.id) end
    end

    test "change_tournaments/1 returns a tournament changeset" do
      tournament = tournaments_fixture()
      assert %Ecto.Changeset{} = Events.change_tournaments(tournament)
    end
  end
end
