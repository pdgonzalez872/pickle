defmodule Pickle.Workflows do
  @moduledoc """
  These are "workflows". Actions we want to take and we want to be able to
  reproduce.

  This is a layer between the controllers and the contexts.
  """

  require Logger

  def scrape_all_tournaments() do
    [
      {"https://apptour.org/the-2022-app-tour-schedule", Pickle.APPParser},
      {"https://www.ppatour.com/ppa-tour", Pickle.PPAParser},
      {"https://usapickleball.org/events/list/?tribe_paged=1&tribe_event_display=list&tribe-bar-date=2022-01-26",
       Pickle.UsaPickleballParser}
    ]
    |> Enum.each(fn {url, parser} ->
      Task.start(fn ->
        scrape_tournaments(url, parser)
      end)
    end)
  end

  def scrape_tournaments(url, parser_mod) do
    with {:ok, html} <- tournament_scraper_impl().get_tournaments(url),
         tournaments <- parser_mod.call(html),
         {_successes, _} <- persist_tournaments(tournaments) do
      Logger.info("Successfully processed #{url}")
      {:ok, %{tournaments: tournaments, html: html}}
    else
      error ->
        Logger.error("Successfully processed #{url}, error: #{error}")
        error
    end
  end

  def persist_tournaments(tournaments_params) do
    tournaments_params_with_timestamps =
      Enum.map(tournaments_params, fn t ->
        t
        |> Map.put(:inserted_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
        |> Map.put(:updated_at, NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second))
      end)

    Pickle.Repo.insert_all(Pickle.Events.Tournament, tournaments_params_with_timestamps)
  end

  defp tournament_scraper_impl() do
    Application.get_env(:pickle, :tournament_scraper, Pickle.TournamentScraperLiveImpl)
  end
end
