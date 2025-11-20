defmodule XmasGiftPollWeb.PersonGiftLive.New do
  use XmasGiftPollWeb, :live_view
  alias XmasGiftPoll.Events
  alias XmasGiftPoll.Events.Gift
  alias XmasGiftPoll.Events.Person

  def mount(%{"public_id" => public_id, "person_public_id" => person_public_id}, _, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    person = Person.get_by_public_id!(person_public_id) |> Events.preload_gifts()

    # If the person has no gifts, we'll start them with 3 empty gift form.
    # Otherwise, we'll show their existing gifts.
    person_with_form_data =
      if Enum.empty?(person.gifts) do
        %{person | gifts: [%Gift{}, %Gift{}, %Gift{}]}
      else
        person
      end

    changeset = Events.change_person(person_with_form_data)

    {:ok,
     socket
     |> assign(:party, party)
     |> assign(:person, person)
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    # When saving, we update the original person struct
    IO.inspect(person_params)

    case Events.update_person(socket.assigns.person, person_params) do
      {:ok, person} ->
        IO.inspect("It is working!")
        IO.inspect(person)

        {:noreply,
         socket
         |> put_flash(:info, "Your gifts have been saved!")
         |> push_patch(
           to:
             ~p"/parties/#{socket.assigns.party.public_id}/people/#{socket.assigns.person.public_id}/gifts"
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect("Something went wrong")
        IO.inspect(changeset)
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("one_more_gift", _params, socket) do
    # To add a new gift form, we add a new empty Gift struct to the form's data
    form = socket.assigns.form
    updated_gifts = form.data.gifts ++ [%Gift{}]
    updated_person = %{form.data | gifts: updated_gifts}

    changeset = Events.change_person(updated_person)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg border border-gray-500 rounded-xl shadow-lg p-4 p-4 mt-10">
      <h1 class="mb-6">
        Welcome <b>{@person.name}</b>! Show people at <b>{@party.name}</b> what you want to get!
      </h1>

      <.form
        for={@form}
        id="gift-form"
        phx-submit="save"
        class="flex flex-col gap-4"
      >
        <% # The `inputs_for` helper renders the nested gift fields %>
        <.inputs_for :let={gift_form} field={@form[:gifts]}>
          <div class="border border-gray-500 p-4 rounded-xl">
            <.input field={gift_form[:name]} type="text" label="Present name" />
            <.input field={gift_form[:description]} type="text" label="Present description" />
          </div>
        </.inputs_for>

        <.button phx-click="one_more_gift" class="btn btn-outline" type="button">
          One more gift
        </.button>

        <.button type="submit">Save Gifts</.button>
      </.form>
    </div>
    """
  end
end
