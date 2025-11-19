defmodule XmasGiftPoll.Events.Person do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias XmasGiftPoll.Repo

  schema "people" do
    field :name, :string
    field :public_id, :string
    belongs_to :party, XmasGiftPoll.Events.Party
    has_many :gifts, XmasGiftPoll.Events.Gift

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :party_id])
    |> validate_required([:name, :party_id])
    |> foreign_key_constraint(:party_id)
    |> put_uuid()
  end

  defp put_uuid(changeset) do
    case get_field(changeset, :public_id) do
      nil -> put_change(changeset, :public_id, Ecto.UUID.generate())
      _ -> changeset
    end
  end

  def get_people_for_party(party_id) do
    query = from p in __MODULE__, where: p.party_id == ^party_id
    Repo.all(query)
  end
end
