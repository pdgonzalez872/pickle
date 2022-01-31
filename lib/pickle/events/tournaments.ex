defmodule Pickle.Events.Tournaments do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournaments" do
    field :address, :string
    field :city, :string
    field :end_date, :naive_datetime
    field :map_link, :string
    field :name, :string
    field :organizer, :string
    field :prize_money, :integer
    field :start_date, :naive_datetime
    field :state, :string
    field :url, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(tournaments, attrs) do
    tournaments
    |> cast(attrs, [
      :address,
      :city,
      :end_date,
      :name,
      :prize_money,
      :start_date,
      :state,
      :url,
      :zip,
      :map_link,
      :organizer
    ])
    |> validate_required([
      :address,
      :city,
      :end_date,
      :name,
      :prize_money,
      :start_date,
      :state,
      :url,
      :zip,
      :map_link,
      :organizer
    ])
  end
end
