defmodule Pickle.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Pickle.Repo

  alias Pickle.Events.Tournaments

  @doc """
  Returns the list of tournaments.

  ## Examples

      iex> list_tournaments()
      [%Tournaments{}, ...]

  """
  def list_tournaments do
    Repo.all(Tournaments)
  end

  @doc """
  Gets a single tournaments.

  Raises `Ecto.NoResultsError` if the Tournaments does not exist.

  ## Examples

      iex> get_tournaments!(123)
      %Tournaments{}

      iex> get_tournaments!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournaments!(id), do: Repo.get!(Tournaments, id)

  @doc """
  Creates a tournaments.

  ## Examples

      iex> create_tournaments(%{field: value})
      {:ok, %Tournaments{}}

      iex> create_tournaments(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournaments(attrs \\ %{}) do
    %Tournaments{}
    |> Tournaments.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournaments.

  ## Examples

      iex> update_tournaments(tournaments, %{field: new_value})
      {:ok, %Tournaments{}}

      iex> update_tournaments(tournaments, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournaments(%Tournaments{} = tournaments, attrs) do
    tournaments
    |> Tournaments.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournaments.

  ## Examples

      iex> delete_tournaments(tournaments)
      {:ok, %Tournaments{}}

      iex> delete_tournaments(tournaments)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournaments(%Tournaments{} = tournaments) do
    Repo.delete(tournaments)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournaments changes.

  ## Examples

      iex> change_tournaments(tournaments)
      %Ecto.Changeset{data: %Tournaments{}}

  """
  def change_tournaments(%Tournaments{} = tournaments, attrs \\ %{}) do
    Tournaments.changeset(tournaments, attrs)
  end
end
