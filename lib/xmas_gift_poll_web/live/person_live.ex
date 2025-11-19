defmodule XmasGiftPollWeb.PersonLive.New do
  use XmasGiftPollWeb, :live_view
  alias XmasGiftPoll.Events

  def mount(%{"public_id" => public_id}, _, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    changeset = Events.change_person(%Events.Person{})

    IO.inspect(party)
    people = Events.Person.get_people_for_party(party.id)

    IO.inspect(people)

    {:ok,
     socket
     |> assign(:party, party)
     |> assign(:people, people)
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

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <h1>Add people to {@party.name}</h1>

      <div>
        <h2>People in the party</h2>
        <ul class="list-disc">
          <%= for person <- @people do %>
            <li>{person.name}</li>
          <% end %>
        </ul>
      </div>

      <.form for={@form} phx-submit="save">
        <.input field={@form[:name]} type="text" label="Person name" />
        <.button>Add Person</.button>
      </.form>
    </div>
    """
  end
end
