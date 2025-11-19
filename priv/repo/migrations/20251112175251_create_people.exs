defmodule XmasGiftPoll.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :party_id, references(:parties, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:people, [:party_id])
  end
end
