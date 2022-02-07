defmodule Pickle.TournamentScraperStaticImpl do
  @moduledoc """
  An implementation of TournamentScraperBehaviour

  This one reads from local files that you can download ahead of time.
  """

  @behaviour Pickle.TournamentScraperBehaviour

  @impl Pickle.TournamentScraperBehaviour
  def get_tournaments(url) do
    # TODO: delete me :)
    with headers <- [Accept: "Application/json; Charset=utf-8"],
         options <- [recv_timeout: 10000],
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} =
           HTTPoison.get(url, headers, options) do
      {:ok, body}
    else
      error ->
        {:ok, "Error sending request to #{url}, error details #{inspect(error)}"}
    end
  end
end
