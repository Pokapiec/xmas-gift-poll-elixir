defmodule XmasGiftPoll.Repo.Migrations.CreateGifts do
  use Ecto.Migration

  def change do
    create table(:gifts) do
      add :name, :string
      add :description, :string
      add :person_id, references(:people, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:gifts, [:person_id])
  end
end
