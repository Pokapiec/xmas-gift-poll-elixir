defmodule XmasGiftPoll.Repo.Migrations.AddReceiverIdToPerson do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :receiver_id, :integer, null: true
    end
  end
end
