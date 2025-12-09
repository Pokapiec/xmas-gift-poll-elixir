defmodule XmasGiftPollWeb.PersonLive.New do
  use XmasGiftPollWeb, :live_view
  alias XmasGiftPoll.Events
  alias XmasGiftPoll.Repo

  def mount(%{"public_id" => public_id}, _, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    changeset = Events.change_person(%Events.Person{})
    party_changeset = Events.change_party(party)

    people =
      Events.Person.get_people_for_party(party.id)
      |> Enum.map(fn p ->
        Map.put(p, :has_defined_gifts, !Enum.empty?(p.gifts))
      end)

    all_shuffled = Enum.all?(people, fn x -> x.receiver_id != nil end)

    {:ok,
     socket
     |> assign(:all_shuffled, all_shuffled)
     |> assign(:party, party)
     |> assign(:people, people)
     |> assign(:page_title, "Define people")
     |> assign(:party_form, to_form(party_changeset))
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

  def handle_event("save_party", %{"party" => party_params}, socket) do
    case Events.update_party(socket.assigns.party, party_params) do
      {:ok, party} ->
        {:noreply,
         socket
         |> put_flash(:info, "Party name changed!")
         |> push_navigate(to: ~p"/parties/#{socket.assigns.party.public_id}/people/new")}

      {:error, changeset} ->
        {:noreply, assign(socket, :party_form, to_form(changeset))}
    end
  end

  def handle_event("shuffle", _params, socket) do
    people = socket.assigns.people
    people_ids = Enum.map(people, fn person -> person.id end)
    shuffled = Events.GiftShuffle.shuffle_gift_assignments(people_ids)

    Enum.each(shuffled, fn {giver_id, receiver_id} ->
      person = Enum.filter(people, fn person -> person.id == giver_id end) |> Enum.at(0)

      Events.change_person(person, %{receiver_id: receiver_id})
      |> Repo.update()
    end)

    {:noreply,
     socket
     |> put_flash(:info, "Shuffled gifts!")
     |> push_navigate(to: ~p"/parties/#{socket.assigns.party.public_id}/people/new")}
  end

  def render(assigns) do
    ~H"""
    <div class="w-full flex justify-center items-center">
      <div class="mx-4 max-w-lg border border-gray-500 rounded-xl shadow-lg p-4 p-4 mt-10">
        <h1 class="">Add people to <b>{@party.name}</b></h1>

        <div class="border-b border-gray-500 w-4/5 mx-auto my-6"></div>

        <div class="border border-gray-500 rounded-xl p-4 mb-6">
          <h2>Change party name</h2>

          <.form for={@party_form} phx-submit="save_party">
            <.input field={@party_form[:name]} type="text" label="Party name" />
            <.button class="btn btn-primary btn-soft w-full mt-4" type="submit">
              Change party name
            </.button>
          </.form>
        </div>

        <div class="border border-gray-500 rounded-xl p-4">
          <h2>People in the party</h2>
          <div class="overflow-x-auto rounded-box border border-base-content/5 bg-base-100 my-4">
            <table class="table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Link for Person</th>
                  <th>Has Defined Gifts</th>
                </tr>
              </thead>
              <%= for person <- @people do %>
                <tr>
                  <td>{person.name}</td>
                  <td>
                    <%= if person.receiver_id != nil do %>
                      <a
                        class="text-blue-500 hover:text-blue-700"
                        href={~p"/parties/#{@party.public_id}/people/#{person.public_id}/gifts"}
                      >
                        link for person
                      </a>
                    <% else %>
                      <p>Shuffle to get link for person</p>
                    <% end %>
                  </td>
                  <td>
                    <%= if person.has_defined_gifts do %>
                      yes
                    <% else %>
                      no
                    <% end %>
                  </td>
                </tr>
              <% end %>
            </table>
          </div>

          <.form for={@form} phx-submit="save">
            <.input field={@form[:name]} type="text" label="Person name" />
            <.button class="btn btn-primary btn-soft w-full mt-4" type="submit">Add person</.button>
          </.form>
        </div>

        <.button
          class="btn btn-primary btn-soft w-full mt-4"
          type="button"
          phx-click="shuffle"
          disabled={@all_shuffled}
        >
          Shuffle people
        </.button>
      </div>
    </div>
    """
  end
end
