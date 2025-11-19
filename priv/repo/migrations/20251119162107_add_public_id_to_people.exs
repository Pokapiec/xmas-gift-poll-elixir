defmodule XmasGiftPoll.Repo.Migrations.AddPublicIdToPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :public_id, :string, null: false
    end

    create unique_index(:people, [:public_id])
  end
end
