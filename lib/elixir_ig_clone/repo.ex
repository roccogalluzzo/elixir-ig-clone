defmodule ElixirIgClone.Repo do
  use Ecto.Repo,
    otp_app: :elixir_ig_clone,
    adapter: Ecto.Adapters.Postgres
end
