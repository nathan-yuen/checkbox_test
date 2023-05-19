defmodule CheckboxTest.Repo do
  use Ecto.Repo,
    otp_app: :checkbox_test,
    adapter: Ecto.Adapters.Postgres
end
