defmodule Pickle.TournamentScraperImpl do
  @moduledoc """
  An implementation of TournamentScraperBehaviour
  """

  @behaviour Pickle.TournamentScraperBehaviour

  def get_tournaments(url) do
    with headers <- ["Accept": "Application/json; Charset=utf-8"],
         options <- [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 5000],
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url, headers, options)
    do
      {:ok, body}
    else
      error ->
        {:ok, "Error sending request to #{url}, error details #{inspect(error)}"}
    end
  end
end
