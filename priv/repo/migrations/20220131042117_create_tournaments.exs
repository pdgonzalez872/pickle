defmodule Pickle.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :address, :string
      add :city, :string
      add :end_date, :utc_datetime
      add :name, :string
      add :prize_money, :integer
      add :start_date, :utc_datetime
      add :state, :string
      add :url, :string
      add :zip, :string
      add :map_link, :string
      add :organizer, :string

      timestamps()
    end
  end
end
