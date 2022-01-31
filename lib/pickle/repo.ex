defmodule Pickle.Repo do
  use Ecto.Repo,
    otp_app: :pickle,
    adapter: Ecto.Adapters.Postgres
end
