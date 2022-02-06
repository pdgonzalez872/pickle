defmodule Pickle.APPParser do
  @moduledoc """
  This was the most annoying one to parse. No css organization, had to deal
  with pattern matching the whole structure.

  Website url:
  https://apptour.org/the-2022-app-tour-schedule
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
      |> Floki.find(".eael-data-table")
      |> then(fn i ->
        [{_, _, [_, {_, _, web}]}, _mobile] = i
        web
      end)
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
    with {:ok, tournament} <- do_tournament_match(e),
         {:ok, tournament} <- get_city_and_state(e, tournament),
         {:ok, tournament} <- get_dates(e, tournament),
         {:ok, tournament} <- get_prize_money(e, tournament),
         tournament <- Map.delete(tournament, :address_state),
         tournament <- Map.put(tournament, :organizer, "app") do
      {:ok, tournament}
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        error
    end
  end

  defp do_tournament_match(
         {"tr", _,
          [
            {_, _,
             [
               {_, _, [{_, _, [dates]}]}
             ]},
            {_, _,
             [
               {_, _,
                [
                  {_, _, [{_, _, [name]}, _, address_state]}
                ]}
             ]},
            _,
            _,
            _,
            {_, _,
             [
               {_, _, [{_, _, [prize_money]}]}
             ]}
          ]}
       ) do
    {:ok,
     %{
       name: name,
       dates: dates,
       address_state: address_state,
       prize_money: prize_money
     }}
  end

  defp do_tournament_match(
         {"tr", _,
          [
            {_, _,
             [
               {_, _, [{_, _, [dates]}]}
             ]},
            {_, _,
             [
               {_, _,
                [
                  {_, _,
                   [
                     {_, _, [{_, _, [name]}, _, address_state]}
                   ]}
                ]}
             ]},
            _,
            _,
            _,
            {_, _,
             [
               {_, _, [{_, _, [prize_money]}]}
             ]}
          ]}
       ) do
    {:ok,
     %{
       name: name,
       dates: dates,
       address_state: address_state,
       prize_money: prize_money
     }}
  end

  defp do_tournament_match(input) do
    {:error, "Not able to match #{inspect(input)}"}
  end

  defp get_city_and_state(_, %{address_state: address_state} = tournament) do
    address_state
    |> String.replace("|", ",")
    |> String.split(",", trim: true)
    |> Enum.map(fn e ->
      e
      |> String.trim_leading()
      |> String.trim_trailing()
    end)
    |> case do
      [_, city, state, _] ->
        tournament
        |> Map.put(:city, city)
        |> Map.put(:state, state)
        |> then(fn e -> {:ok, e} end)

      [country, "International"] ->
        tournament
        |> Map.put(:city, "International")
        |> Map.put(:state, country)
        |> then(fn e -> {:ok, e} end)

      [country, "International", _] ->
        tournament
        |> Map.put(:city, "International")
        |> Map.put(:state, country)
        |> then(fn e -> {:ok, e} end)

      [state, _] ->
        tournament
        |> Map.put(:city, "Unknown")
        |> Map.put(:state, state)
        |> then(fn e -> {:ok, e} end)

      error ->
        {:error, "Could not get city and state from #{inspect(error)}"}
    end
  end

  defp get_dates(
         _floki_event,
         %{
           dates: dates
         } = tournament
       ) do
    months = %{
      "JAN" => 1,
      "FEB" => 2,
      "MAR" => 3,
      "APR" => 4,
      "MAY" => 5,
      "JUN" => 6,
      "JUL" => 7,
      "AUG" => 8,
      "SEP" => 9,
      "OCT" => 10,
      "NOV" => 11,
      "DEC" => 12
    }

    dates
    |> String.replace(",", "")
    |> String.replace("-", "")
    |> String.replace("–", "")
    |> String.split(" ", trim: true)
    |> case do
      _same_month = [start_month, start_day, end_day, year] ->
        {:ok,
         %{
           start_date: adjust_date([year, start_month, start_day], months),
           end_date: adjust_date([year, start_month, end_day], months)
         }}

      _overlapping_month = [start_month, start_day, end_month, end_day, year] ->
        {:ok,
         %{
           start_date: adjust_date([year, start_month, start_day], months),
           end_date: adjust_date([year, end_month, end_day], months)
         }}

      _no_start_day_and_end_date = [start_month, year] ->
        {:ok,
         %{
           start_date: adjust_date([year, start_month, "1"], months),
           end_date: nil
         }}

      no_match ->
        {:error, "Unable to parse dates, #{inspect(no_match)}"}
    end
    |> then(fn
      {:ok, dates} -> {:ok, Map.merge(tournament, dates)}
      error -> error
    end)
  end

  defp get_prize_money(_floki_event, %{prize_money: raw_prize_money} = tournament) do
    raw_prize_money
    |> String.replace("$", "")
    |> String.replace("K", "")
    |> then(fn
      "TBA" ->
        0

      to_parse ->
        case Integer.parse(to_parse) do
          {i, _} -> i
          error -> "Unable to parse #{to_parse}, error: #{inspect(error)}"
        end
    end)
    |> then(fn
      prize_money when is_integer(prize_money) ->
        {:ok, Map.put(tournament, :prize_money, prize_money)}

      error ->
        {:error, "Unable to parse prize_money, error: #{error}"}
    end)
  end

  defp adjust_date([year_int, month_abbr, day_int], months) do
    with month <- Map.get(months, month_abbr),
         {day, _} <- Integer.parse(day_int),
         {year, _} <- Integer.parse(year_int) do
      DateTime.new!(Date.new!(year, month, day), Time.utc_now())
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        nil
    end
  end
end
