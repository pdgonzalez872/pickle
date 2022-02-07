defmodule Pickle.TournamentScraperLiveImpl do
  @moduledoc """
  An implementation of TournamentScraperBehaviour

  This one sends live requests.
  """

  @behaviour Pickle.TournamentScraperBehaviour

  @impl Pickle.TournamentScraperBehaviour
  def get_tournaments(url) do
    url
    |> Req.get!()
    |> case do
      %{status: 200, body: body} -> {:ok, body}
      error -> {:error, "Error sending request to #{url}, error details #{inspect(error)}"}
    end
  end
end
