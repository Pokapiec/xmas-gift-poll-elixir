defmodule XmasGiftPoll.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `XmasGiftPoll.Events` context.
  """

  @doc """
  Generate a party.
  """
  def party_fixture(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> XmasGiftPoll.Events.create_party()

    party
  end

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> XmasGiftPoll.Events.create_person()

    person
  end

  @doc """
  Generate a gift.
  """
  def gift_fixture(attrs \\ %{}) do
    {:ok, gift} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> XmasGiftPoll.Events.create_gift()

    gift
  end
end
