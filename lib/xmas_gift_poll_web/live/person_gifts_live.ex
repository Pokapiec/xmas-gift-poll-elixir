defmodule XmasGiftPollWeb.PersonGiftLive.New do
  use XmasGiftPollWeb, :live_view
  use Gettext, backend: XmasGiftPollWeb.Gettext
  alias XmasGiftPoll.Events
  alias XmasGiftPoll.Events.Gift
  alias XmasGiftPoll.Events.Person
  alias XmasGiftPoll.Repo

  def mount(%{"public_id" => public_id, "person_public_id" => person_public_id}, _, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    person = Person.get_by_public_id!(person_public_id) |> Events.preload_gifts()
    receiver = Repo.get(Person, person.receiver_id) |> Events.preload_gifts()

    has_defined_gifts = !Enum.empty?(person.gifts)

    # If the person has no gifts, we'll start them with 3 empty gift form.
    # Otherwise, we'll show their existing gifts.
    person_with_form_data =
      if has_defined_gifts do
        person
      else
        %{person | gifts: [%Gift{}, %Gift{}, %Gift{}]}
      end

    changeset = Events.change_person(person_with_form_data)

    {:ok,
     socket
     |> assign(:has_defined_gifts, has_defined_gifts)
     |> assign(:party, party)
     |> assign(:person, person)
     |> assign(:receiver, receiver)
     |> assign(:page_title, gettext("Gift definition"))
     |> assign(:form, to_form(changeset))}
  end

  def handle_params(params, _uri, socket) do
    locale =
      case params do
        %{"locale" => "en"} -> "en"
        _ -> "pl"
      end

    Gettext.put_locale(XmasGiftPollWeb.Gettext, locale)
    {:noreply, socket}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    # When saving, we update the original person struct
    case Events.update_person(socket.assigns.person, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Your gifts have been saved!"))
         |> push_navigate(
           to:
             ~p"/parties/#{socket.assigns.party.public_id}/people/#{socket.assigns.person.public_id}/gifts"
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
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
    <div class="fixed top-4 right-4 md:top-10 md:right-10">
      <div class="dropdown">
        <div tabindex="0" role="button" class="btn m-1">Lang</div>
        <ul tabindex="-1" class="dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm">
          <li><a href="?locale=en">EN</a></li>
          <li><a href="?locale=pl">PL</a></li>
        </ul>
      </div>
    </div>

    <div class="w-full flex justify-center items-center">
      <div class="mx-4 max-w-lg border border-gray-500 rounded-xl shadow-lg p-4 p-4 mt-22">
        <h1 class="mb-6">
          {gettext("Welcome %{name}! Show people at %{party} what you want to get!",
            name: @person.name,
            party: @party.name
          )}
        </h1>

        <%= if !@has_defined_gifts do %>
          <.form
            for={@form}
            id="gift-form"
            phx-submit="save"
            class="flex flex-col gap-4"
          >
            <div class="border border-gray-500 p-4 rounded-xl">
              <h3>{gettext("Define what you want to get")}</h3>
              <% # The `inputs_for` helper renders the nested gift fields %>
              <.inputs_for :let={gift_form} field={@form[:gifts]}>
                <.input field={gift_form[:name]} type="textarea" />
              </.inputs_for>

              <.button phx-click="one_more_gift" class="btn btn-outline" type="button">
                <svg
                  class="size-8"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="currentColor"
                  class="bi bi-plus"
                  viewBox="0 0 16 16"
                >
                  <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4" />
                </svg>
              </.button>
            </div>

            <.button type="submit">{gettext("Save Gifts")}</.button>
          </.form>
        <% else %>
          <div class="border border-gray-500 p-4 rounded-xl">
            <h2 class="mb-6 font-semibold text-md">
              {gettext("You are buying present for '%{name}' and he/she wants:",
                name: @receiver.name
              )}
            </h2>
            <ul class="flex flex-col gap-4">
              <%= if Enum.empty?(@receiver.gifts) do %>
                <p>
                  {gettext("%{name} hasn't defined their wishlist yet :(",
                    name: @receiver.name
                  )}
                </p>
              <% else %>
                <%= for gift <- @receiver.gifts do %>
                  <li><textarea class="w-full textarea" disabled>{gift.name}</textarea></li>
                <% end %>
              <% end %>
            </ul>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
