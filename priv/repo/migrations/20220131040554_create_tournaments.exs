defmodule Pickle.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :address, :string
      add :city, :string
      add :end_date, :naive_datetime
      add :name, :string
      add :prize_money, :integer
      add :start_date, :naive_datetime
      add :state, :string
      add :url, :string
      add :zip, :string
      add :map_link, :string
      add :organizer, :string

      timestamps()
    end
  end
end
