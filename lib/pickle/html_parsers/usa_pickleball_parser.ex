defmodule Pickle.UsaPickleballParser do
  @moduledoc false

  require Logger

  @tournament_year 2022

  @doc """
  Takes in html and parses it accordingly
  """
  def call(html) do
    state = %{}

    html
    |> Floki.parse_document!()
    |> then(fn document ->
      document
      |> Floki.find(".type-tribe_events")
      |> Enum.map(fn e -> parse_tournament(e) end)
    end)
    |> then(fn e -> Map.put(state, :tournaments, e) end)
  end

  def parse_tournament(e) do
    with {:ok, tournament} <- get_name(e, %{}),
         {:ok, tournament} <- get_url(e, tournament),
         {:ok, tournament} <- get_start_date(e, tournament),
         {:ok, tournament} <- get_end_date(e, tournament),
         tournament <- adjust_dates(tournament),
         {:ok, tournament} <- get_address(e, tournament),
         {:ok, tournament} <- get_city(e, tournament),
         {:ok, tournament} <- get_state(e, tournament),
         {:ok, tournament} <- get_zip(e, tournament),
         {:ok, tournament} <- get_map_link(e, tournament),
         tournament <- get_prize_money(e, tournament),
         tournament <- Map.put(tournament, :organizer, "usa_pickleball") do
      tournament
    else
      error ->
        Logger.error("Error: #{inspect(error)}")
        error
    end
  end

  defp get_name(floki_event, tournament) do
    matching_fun = fn
      [{_, [_, {_, _url}, {_, match}, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-url", matching_fun, tournament, :name)
  end

  defp get_url(floki_event, tournament) do
    matching_fun = fn
      [{_, [_, {_, match}, {_, _name}, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-url", matching_fun, tournament, :url)
  end

  defp get_start_date(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-date-start", matching_fun, tournament, :start_date)
  end

  defp get_end_date(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-date-end", matching_fun, tournament, :end_date)
  end

  defp get_address(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-street-address", matching_fun, tournament, :address)
  end

  defp get_city(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-locality", matching_fun, tournament, :city)
  end

  defp get_state(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-events-abbr", matching_fun, tournament, :state)
  end

  defp get_zip(floki_event, tournament) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-postal-code", matching_fun, tournament, :zip)
  end

  defp get_map_link(floki_event, tournament) do
    matching_fun = fn
      [{_, [_, {_, match}, _, _, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-events-gmap", matching_fun, tournament, :map_link)
  end

  defp get_prize_money(_floki_event, %{name: name} = tournament) do
    prize_money =
      name
      |> String.split(" ", trim: true)
      |> Enum.filter(fn e -> String.contains?(e, "$") end)
      |> case do
        [match] -> match |> String.replace("$", "") |> String.replace("K", "")
        _ -> "0"
      end
      |> then(fn to_parse ->
        {i, _} = Integer.parse(to_parse)
        i
      end)

    Map.put(tournament, :prize_money, prize_money)
  end

  defp do_get(floki_event, class, matching_fun, state, key_to_update) do
    floki_event
    |> Floki.find(class)
    |> matching_fun.()
    |> case do
      nil ->
        # Missing data seems to be common in those websites
        Logger.warn("Missing data -> Setting #{key_to_update} to nil for #{inspect(state)}")
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
    [month_name, day] = String.split(improper_date, " ", trim: true)

    month = Map.get(months, month_name)
    {day, _} = Integer.parse(day)
    DateTime.new!(Date.new!(@tournament_year, month, day), Time.utc_now())
  end
end
