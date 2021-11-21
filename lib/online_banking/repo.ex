defmodule OnlineBanking.Repo do
  use Ecto.Repo,
    otp_app: :online_banking,
    adapter: Ecto.Adapters.Postgres
end
