defmodule XmasGiftPoll.EventsTest do
  use XmasGiftPoll.DataCase

  alias XmasGiftPoll.Events

  describe "parties" do
    alias XmasGiftPoll.Events.Party

    import XmasGiftPoll.EventsFixtures

    @invalid_attrs %{name: nil}

    test "list_parties/0 returns all parties" do
      party = party_fixture()
      assert Events.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = party_fixture()
      assert Events.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Party{} = party} = Events.create_party(valid_attrs)
      assert party.name == "some name"
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = party_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Party{} = party} = Events.update_party(party, update_attrs)
      assert party.name == "some updated name"
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = party_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_party(party, @invalid_attrs)
      assert party == Events.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = party_fixture()
      assert {:ok, %Party{}} = Events.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Events.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = party_fixture()
      assert %Ecto.Changeset{} = Events.change_party(party)
    end
  end

  describe "people" do
    alias XmasGiftPoll.Events.Person

    import XmasGiftPoll.EventsFixtures

    @invalid_attrs %{name: nil}

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Events.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Events.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Person{} = person} = Events.create_person(valid_attrs)
      assert person.name == "some name"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Person{} = person} = Events.update_person(person, update_attrs)
      assert person.name == "some updated name"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_person(person, @invalid_attrs)
      assert person == Events.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Events.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Events.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Events.change_person(person)
    end
  end

  describe "gifts" do
    alias XmasGiftPoll.Events.Gift

    import XmasGiftPoll.EventsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_gifts/0 returns all gifts" do
      gift = gift_fixture()
      assert Events.list_gifts() == [gift]
    end

    test "get_gift!/1 returns the gift with given id" do
      gift = gift_fixture()
      assert Events.get_gift!(gift.id) == gift
    end

    test "create_gift/1 with valid data creates a gift" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Gift{} = gift} = Events.create_gift(valid_attrs)
      assert gift.name == "some name"
      assert gift.description == "some description"
    end

    test "create_gift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_gift(@invalid_attrs)
    end

    test "update_gift/2 with valid data updates the gift" do
      gift = gift_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Gift{} = gift} = Events.update_gift(gift, update_attrs)
      assert gift.name == "some updated name"
      assert gift.description == "some updated description"
    end

    test "update_gift/2 with invalid data returns error changeset" do
      gift = gift_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_gift(gift, @invalid_attrs)
      assert gift == Events.get_gift!(gift.id)
    end

    test "delete_gift/1 deletes the gift" do
      gift = gift_fixture()
      assert {:ok, %Gift{}} = Events.delete_gift(gift)
      assert_raise Ecto.NoResultsError, fn -> Events.get_gift!(gift.id) end
    end

    test "change_gift/1 returns a gift changeset" do
      gift = gift_fixture()
      assert %Ecto.Changeset{} = Events.change_gift(gift)
    end
  end
end
