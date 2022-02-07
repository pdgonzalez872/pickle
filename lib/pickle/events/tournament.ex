defmodule Pickle.Events.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tournaments" do
    field :address, :string
    field :city, :string
    field :end_date, :date
    field :map_link, :string
    field :name, :string
    field :organizer, :string
    field :prize_money, :integer
    field :start_date, :date
    field :state, :string
    field :url, :string
    field :zip, :string

    timestamps()
  end

  @required [
    :name,
    :prize_money,
    :start_date,
    :organizer
  ]

  @optional [
    :address,
    :city,
    :end_date,
    :map_link,
    :state,
    :url,
    :zip
  ]

  @all @required ++ @optional

  @doc false
  def changeset(tournaments, attrs) do
    tournaments
    |> cast(attrs, @all)
    |> validate_required(@required)
  end
end
