defmodule XmasGiftPollWeb.PersonLive.New do
  use XmasGiftPollWeb, :live_view
  alias XmasGiftPoll.Events
  alias XmasGiftPoll.Repo

  def mount(%{"public_id" => public_id}, _, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    changeset = Events.change_person(%Events.Person{})

    people = Events.Person.get_people_for_party(party.id)

    {:ok,
     socket
     |> assign(:party, party)
     |> assign(:people, people)
     |> assign(:page_title, "Define people")
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    params = Map.put(person_params, "party_id", socket.assigns.party.id)

    case Events.create_person(params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person added!")
         |> push_patch(to: ~p"/parties/#{socket.assigns.party.public_id}/people/new")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("shuffle", _params, socket) do
    people = socket.assigns.people
    people_ids = Enum.map(people, fn person -> person.id end)
    shuffled = Events.GiftShuffle.shuffle_gift_assignments(people_ids)
    IO.inspect(shuffled)

    Enum.each(shuffled, fn {giver_id, receiver_id} ->
      person = Enum.filter(people, fn person -> person.id == giver_id end) |> Enum.at(0)

      res =
        Events.change_person(person, %{receiver_id: receiver_id})
        |> Repo.update()

      IO.inspect(res)
    end)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg border border-gray-500 rounded-xl shadow-lg p-4 p-4 mt-10">
      <h1 class="">Add people to <b>{@party.name}</b></h1>

      <div class="border-b border-gray-500 w-4/5 mx-auto my-6"></div>

      <div class="border border-gray-500 rounded-xl p-4">
        <h2>People in the party</h2>
        <ul>
          <%= for person <- @people do %>
            <li>
              <div class="flex flex-row gap-2 items-center">
                <.input value={person.name} name="name" type="text" /> -
                <a
                  class="text-blue-500 hover:text-blue-700"
                  href={~p"/parties/#{@party.public_id}/people/#{person.public_id}/gifts"}
                >
                  link for gift assigning
                </a>
              </div>
            </li>
          <% end %>
        </ul>

        <.form for={@form} phx-submit="save">
          <.input field={@form[:name]} type="text" label="Person name" />
          <.button class="btn btn-primary btn-soft w-full mt-4" type="submit">Add person</.button>
        </.form>
      </div>

      <.button class="btn btn-primary btn-soft w-full mt-4" type="button" phx-click="shuffle">
        Shuffle people
      </.button>
    </div>
    """
  end
end
