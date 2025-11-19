defmodule XmasGiftPoll.Repo do
  use Ecto.Repo,
    otp_app: :xmas_gift_poll,
    adapter: Ecto.Adapters.SQLite3
end
