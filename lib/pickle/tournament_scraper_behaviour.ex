defmodule Pickle.TournamentScraperBehaviour do
  @callback get_tournaments(binary()) :: {:ok, map()} | {:error, binary()}
end
