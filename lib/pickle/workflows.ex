defmodule Pickle.Workflows do
  @moduledoc false

  require Logger

  def scrape_tournaments(url, parser_mod) do
    with {:ok, html} <- tournament_scraper_impl().get_tournaments(url),
         tournaments <- %{}
         # tournaments <- parser_mod.call(html)
    do
      Logger.info("Successfully processed #{url}")
      {:ok, %{tournaments: tournaments, html: html}}
    else
      error ->
        Logger.error("Successfully processed #{url}, error: #{error}")
        error
    end
  end

  defp tournament_scraper_impl() do
    Application.get_env(:pickle, :tournament_scraper, Pickle.TournamentScraperImpl)
  end
end
