defmodule Pickle.PPAParser do
  @moduledoc """
  This type of tournament is interesting: There seems to be different payouts
  for each tournament type. Unfortunately, I don't seem to be able to derive
  which tournament type an event is. For now, will set the prize money as their
  smallest prize money amount: $120K. Prize money ranges from 120 - 160.

  More info: https://www.ppatour.com/tour-payouts

  Website url:
  https://www.ppatour.com/ppa-tour
  """

  require Logger

  @doc """
  Takes in html and parses it accordingly
  """
  def call(html) do
    html
    |> Floki.parse_document!()
    |> then(fn document ->
      document
      |> Floki.find(".evcal_list_a")
      |> Enum.map(fn e ->
        e
        |> parse_tournament()
        |> case do
          {:ok, tournament} -> tournament
          _ -> nil
        end
      end)
      |> Enum.reject(fn e -> is_nil(e) end)
    end)
  end

  def parse_tournament(e) do
    with {:ok, tournament} <- get_name(e, %{}),
         {:ok, tournament} <- get_url(e, tournament),
         {:ok, tournament} <- get_start_date(e, tournament),
         {:ok, tournament} <- get_end_date(e, tournament),
         tournament <- adjust_dates(tournament),
         {:ok, tournament} <- get_address_city_and_state(e, tournament),
         tournament <- get_prize_money(e, tournament),
         tournament <- Map.put(tournament, :organizer, "ppa") do
      {:ok, tournament}
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        error
    end
  end

  defp get_name(floki_event, tournament) do
    matching_fun = fn
      [
        {_, [_, _, {_, _address_city_state}, _, _, {_, _url}, _],
         [_, {_, [_, _], [match]}, _, _, _]}
      ] ->
        match

      [{_, _, [match]}] ->
        match

      _ ->
        nil
    end

    case do_get(floki_event, ".evo_info", matching_fun, tournament, :name) do
      {:ok, %{name: nil} = tournament} ->
        matching_fun = fn
          [{_, _, [match]}] -> match
          _ -> nil
        end

        do_get(floki_event, ".evcal_event_title", matching_fun, tournament, :name)

      success ->
        success
    end
  end

  defp get_url({_, [_, _, _, _, _, _, _, {_, url}, _], _}, tournament) do
    {:ok, Map.put(tournament, :url, url)}
  end

  defp get_url(floki_event, tournament) do
    # if tournament.name == "Ororo PPA Indoor National Championships" do
    #   require IEx; IEx.pry
    # end

    matching_fun = fn
      [
        {_, [_, _, {_, _address_city_state}, _, _, {_, match}, _],
         [_, {_, [_, _], [_name]}, _, _, _]}
      ] ->
        match

      _ ->
        nil
    end

    do_get(floki_event, ".evo_info", matching_fun, tournament, :url)
  end

  defp get_start_date(floki_event, tournament) do
    matching_fun = fn
      [
        {_, [_, _, {_, month}, {_, year}],
         [{_, _, [{_, _, [start_day]}, _, _]}, {_, _, [{_, _, [_end_day]}, _]}, _]}
      ] ->
        "#{year} #{month} #{start_day}"

      [
        {_, [_, _, {_, month}, {_, year}],
         [{_, _, [{_, _, [start_day]}, _, _]}, {_, _, [{_, _, [_end_day]}]}, _]}
      ] ->
        "#{year} #{month} #{start_day}"

      _ ->
        nil
    end

    do_get(floki_event, ".evcal_cblock", matching_fun, tournament, :start_date)
  end

  defp get_end_date(floki_event, tournament) do
    matching_fun = fn
      [
        {_, [_, _, {_, month}, {_, year}],
         [{_, _, [{_, _, [_start_day]}, _, _]}, {_, _, [{_, _, [end_day]}, _]}, _]}
      ] ->
        "#{year} #{month} #{end_day}"

      [
        {_, [_, _, {_, month}, {_, year}],
         [{_, _, [{_, _, [_start_day]}, _, _]}, {_, _, [{_, _, [end_day]}]}, _]}
      ] ->
        "#{year} #{month} #{end_day}"

      _ ->
        nil
    end

    do_get(floki_event, ".evcal_cblock", matching_fun, tournament, :end_date)
  end

  defp get_address_city_and_state(floki_event, tournament) do
    matching_fun = fn
      [{_, [_, _, {_, match}, _, _, {_, _url}, _], [_, {_, [_, _], [_name]}, _, _, _]}] -> match
      _ -> nil
    end

    case do_get(floki_event, ".evo_info", matching_fun, tournament, :address) do
      {:ok, %{address: nil} = tournament} = no_address ->
        Logger.info("Unable to get_address_city_and_state for #{inspect(tournament)}")
        no_address

      {:ok, %{address: address_city_state} = tournament} ->
        address_city_state
        |> String.split(", ")
        |> Enum.map(fn e ->
          e
          |> String.trim_leading()
          |> String.trim_trailing()
        end)
        |> handle_address_split(tournament)

      error ->
        Logger.info(
          "Unable to get_address_city_and_state for #{inspect(tournament)}, error: #{error}"
        )
    end
  end

  defp handle_address_split([address, city, state], tournament) do
    tournament
    |> Map.put(:address, address)
    |> Map.put(:city, city)
    |> Map.put(:state, state)
    |> then(fn tournament -> {:ok, tournament} end)
  end

  defp handle_address_split([address], tournament) do
    tournament =
      tournament
      |> Map.put(:address, address)

    {:ok, tournament}
  end

  defp get_prize_money(_floki_event, tournament) do
    # Using the smallest amount of prize money for these tournaments
    Map.put(tournament, :prize_money, 120)
  end

  defp do_get(floki_event, class, matching_fun, state, key_to_update) do
    floki_event
    |> Floki.find(class)
    |> matching_fun.()
    |> case do
      nil ->
        # Missing data seems to be common in those websites
        Logger.info("Missing data -> Setting #{key_to_update} to nil for #{inspect(state)}")
        {:ok, Map.put(state, key_to_update, nil)}

      value_to_update ->
        {:ok, Map.put(state, key_to_update, value_to_update)}
    end
  end

  defp adjust_dates(%{start_date: improper_start_date, end_date: improper_end_date} = tournament) do
    months = %{
      "January" => 1,
      "February" => 2,
      "March" => 3,
      "April" => 4,
      "May" => 5,
      "June" => 6,
      "July" => 7,
      "August" => 8,
      "September" => 9,
      "October" => 10,
      "November" => 11,
      "December" => 12
    }

    [start_date, end_date] =
      Enum.map([improper_start_date, improper_end_date], fn improper_date ->
        adjust_date(improper_date, months)
      end)

    tournament
    |> Map.put(:start_date, start_date)
    |> Map.put(:end_date, end_date)
  end

  defp adjust_date(nil, _) do
    nil
  end

  defp adjust_date(improper_date, months) do
    with [year, month_name, day] <- String.split(improper_date, " ", trim: true),
         {year, _} <- Integer.parse(year),
         month <- Map.get(months, String.capitalize(month_name)),
         {day, _} <- Integer.parse(day) do
      Date.new!(year, month, day)
      |> DateTime.new!(Time.utc_now())
      |> DateTime.truncate(:second)
    else
      _error -> nil
    end
  end
end
