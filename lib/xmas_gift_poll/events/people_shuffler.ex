defmodule XmasGiftPoll.Events.GiftShuffle do
  # Public entry point
  def shuffle_gift_assignments(person_ids) do
    do_shuffle(person_ids)
  end

  # Keep shuffling until no one is assigned to themselves
  defp do_shuffle(person_ids) do
    shuffled = Enum.shuffle(person_ids)

    if Enum.zip(person_ids, shuffled)
       |> Enum.any?(fn {giver, receiver} -> giver == receiver end) do
      # try again
      do_shuffle(person_ids)
    else
      Enum.zip(person_ids, shuffled)
      |> Map.new()
    end
  end
end
