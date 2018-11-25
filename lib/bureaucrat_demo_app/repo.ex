defmodule BureaucratDemoApp.Repo do
  use Ecto.Repo,
    otp_app: :bureaucrat_demo_app,
    adapter: Ecto.Adapters.Postgres

  use Paginator, limit: 10
end
