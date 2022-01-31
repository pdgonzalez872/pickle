defmodule Pickle.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pickle.Events` context.
  """

  @doc """
  Generate a tournaments.
  """
  def tournaments_fixture(attrs \\ %{}) do
    {:ok, tournaments} =
      attrs
      |> Enum.into(%{
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
      })
      |> Pickle.Events.create_tournaments()

    tournaments
  end
end
