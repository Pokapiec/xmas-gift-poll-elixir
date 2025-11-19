defmodule XmasGiftPoll.Events.Party do
  use Ecto.Schema
  import Ecto.Changeset
  alias XmasGiftPoll.Repo

  schema "parties" do
    field :name, :string
    field :public_id, :string
    has_many :people, XmasGiftPoll.Events.Person

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(party, attrs) do
    party
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_uuid()
  end

  defp put_uuid(changeset) do
    case get_field(changeset, :public_id) do
      nil -> put_change(changeset, :public_id, Ecto.UUID.generate())
      _ -> changeset
    end
  end

  def get_party_by_public_id!(public_id) do
    Repo.get_by!(__MODULE__, public_id: public_id)
  end
end
