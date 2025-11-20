defmodule XmasGiftPoll.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias XmasGiftPoll.Repo

  alias XmasGiftPoll.Events.Party

  @doc """
  Returns the list of parties.

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(Party)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id)

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs) do
    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{data: %Party{}}

  """
  def change_party(%Party{} = party, attrs \\ %{}) do
    Party.changeset(party, attrs)
  end

  alias XmasGiftPoll.Events.Person

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%Person{}, ...]

  """
  def list_people do
    Repo.all(Person)
  end

  @doc """
  Returns the list of people for a given party.

  ## Examples

      iex> list_people_for_party(party_id)
      [%Person{}, ...]

  """
  def list_people_for_party(party_id) do
    Repo.all(from p in Person, where: p.party_id == ^party_id)
  end


  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end

  def preload_gifts(%Person{} = person) do
    Repo.preload(person, :gifts)
  end

  alias XmasGiftPoll.Events.Gift

  @doc """
  Returns the list of gifts.

  ## Examples

      iex> list_gifts()
      [%Gift{}, ...]

  """
  def list_gifts do
    Repo.all(Gift)
  end

  @doc """
  Gets a single gift.

  Raises `Ecto.NoResultsError` if the Gift does not exist.

  ## Examples

      iex> get_gift!(123)
      %Gift{}

      iex> get_gift!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gift!(id), do: Repo.get!(Gift, id)

  @doc """
  Creates a gift.

  ## Examples

      iex> create_gift(%{field: value})
      {:ok, %Gift{}}

      iex> create_gift(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gift(attrs) do
    %Gift{}
    |> Gift.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gift.

  ## Examples

      iex> update_gift(gift, %{field: new_value})
      {:ok, %Gift{}}

      iex> update_gift(gift, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gift(%Gift{} = gift, attrs) do
    gift
    |> Gift.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gift.

  ## Examples

      iex> delete_gift(gift)
      {:ok, %Gift{}}

      iex> delete_gift(gift)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gift(%Gift{} = gift) do
    Repo.delete(gift)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gift changes.

  ## Examples

      iex> change_gift(gift)
      %Ecto.Changeset{data: %Gift{}}

  """
  def change_gift(%Gift{} = gift, attrs \\ %{}) do
    Gift.changeset(gift, attrs)
  end
end
