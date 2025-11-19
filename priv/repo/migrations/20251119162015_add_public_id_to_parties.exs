defmodule XmasGiftPoll.Repo.Migrations.AddPublicIdToParties do
  use Ecto.Migration

  def change do
    alter table(:parties) do
      add :public_id, :string, null: false
    end

    create unique_index(:parties, [:public_id])
  end
end
