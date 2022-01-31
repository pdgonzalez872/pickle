defmodule Pickle.APPParser do
  @moduledoc false

  require Logger

  def call(full_file_path) do
    state = init(full_file_path)

    full_file_path
    |> File.read!()
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
    |> then(fn e -> Map.put(state, :tournaments, e) end)
  end

  defp init(full_file_path) do
    %{full_file_path: full_file_path}
  end

  def parse_tournament(e) do
    with {:ok, tournament_state} <- do_tournament_match(e),
         {:ok, tournament_state} <- get_city_and_state(tournament_state),
         tournament_state <- Map.delete(tournament_state, :address_state),
         tournament_state <- Map.put(tournament_state, :organizer, "APP") do
      {:ok, tournament_state}
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

  defp get_city_and_state(%{address_state: address_state} = tournament_state) do
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
        tournament_state
        |> Map.put(:city, city)
        |> Map.put(:state, state)
        |> then(fn e -> {:ok, e} end)

      [country, "International"] ->
        tournament_state
        |> Map.put(:city, "International")
        |> Map.put(:state, country)
        |> then(fn e -> {:ok, e} end)

      [country, "International", _] ->
        tournament_state
        |> Map.put(:city, "International")
        |> Map.put(:state, country)
        |> then(fn e -> {:ok, e} end)

      [state, _] ->
        tournament_state
        |> Map.put(:city, "Unknown")
        |> Map.put(:state, state)
        |> then(fn e -> {:ok, e} end)

      error ->
        {:error, "Could not get city and state from #{inspect(error)}"}
    end
  end

  defp get_name(floki_event, tournament_state) do
    matching_fun = fn
      [{_, [_, {_, _url}, {_, match}, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-url", matching_fun, tournament_state, :name)
  end

  defp get_url(floki_event, tournament_state) do
    matching_fun = fn
      [{_, [_, {_, match}, {_, _name}, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-url", matching_fun, tournament_state, :url)
  end

  defp get_start_date(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-date-start", matching_fun, tournament_state, :start_date)
  end

  defp get_end_date(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-event-date-end", matching_fun, tournament_state, :end_date)
  end

  defp get_address(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-street-address", matching_fun, tournament_state, :address)
  end

  defp get_city(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-locality", matching_fun, tournament_state, :city)
  end

  defp get_state(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-events-abbr", matching_fun, tournament_state, :state)
  end

  defp get_zip(floki_event, tournament_state) do
    matching_fun = fn
      [{_, _, [match]}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-postal-code", matching_fun, tournament_state, :zip)
  end

  defp get_map_link(floki_event, tournament_state) do
    matching_fun = fn
      [{_, [_, {_, match}, _, _, _], _}] -> match
      _ -> nil
    end

    do_get(floki_event, ".tribe-events-gmap", matching_fun, tournament_state, :map_link)
  end

  defp get_prize_money(_floki_event, %{name: name} = tournament_state) do
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

    Map.put(tournament_state, :prize_money, prize_money)
  end

  defp do_get(floki_event, class, matching_fun, state, key_to_update) do
    floki_event
    |> Floki.find(class)
    |> matching_fun.()
    |> then(fn e -> Map.put(state, key_to_update, e) end)
  end

  defp adjust_dates(
         %{start_date: improper_start_date, end_date: improper_end_date} = tournament_state
       ) do
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

    tournament_state
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
    DateTime.new!(Date.new!(2022, month, day), Time.utc_now())
  end
end
