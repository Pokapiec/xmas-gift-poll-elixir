defmodule XmasGiftPoll.Events.Gift do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gifts" do
    field :name, :string
    field :description, :string
    belongs_to :person, XmasGiftPoll.Events.Person

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gift, attrs) do
    gift
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> foreign_key_constraint(:person_id)
  end
end
