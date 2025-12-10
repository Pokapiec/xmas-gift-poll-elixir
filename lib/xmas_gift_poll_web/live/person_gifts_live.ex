defmodule XmasGiftPollWeb.PersonGiftLive.New do
  use XmasGiftPollWeb, :live_view
  use Gettext, backend: XmasGiftPollWeb.Gettext
  alias XmasGiftPoll.Events
  alias XmasGiftPoll.Events.Gift
  alias XmasGiftPoll.Events.Person
  alias XmasGiftPoll.Repo

  def mount(%{"public_id" => public_id, "person_public_id" => person_public_id}, uri, socket) do
    party = Events.Party.get_party_by_public_id!(public_id)
    person = Person.get_by_public_id!(person_public_id) |> Events.preload_gifts()
    receiver = Repo.get(Person, person.receiver_id) |> Events.preload_gifts()
    gift_changeset = Events.change_gift(%Events.Gift{})
    gifts = Events.get_gifts_for_person(person.id)

    has_defined_gifts = Enum.count(person.gifts) >= 3

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
     |> assign(:uri, uri)
     |> assign(:gifts, gifts)
     |> assign(:page_title, gettext("Gift definition"))
     |> assign(:gift_form, to_form(gift_changeset))
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

  def handle_event("add_gift", %{"gift" => gift_params}, socket) do
    modified_gift_params = gift_params |> Map.put("person_id", socket.assigns.person.id)

    case Events.create_gift(modified_gift_params) do
      {:ok, _gift} ->
        {:noreply,
         socket
         |> put_flash(:info, "Gift added!")
         |> push_navigate(to: socket.assigns.uri.path)}

      {:error, changeset} ->
        {:noreply, assign(socket, :gift_form, to_form(changeset))}
    end
  end

  def handle_event("delete_gift", %{"gift-id" => gift_id}, socket) do
    gift = Events.get_gift!(gift_id)

    # Verify the gift belongs to the current person (security check)
    if gift.person_id == socket.assigns.person.id do
      case Events.delete_gift(gift) do
        {:ok, _gift} ->
          updated_gifts =
            Enum.reject(socket.assigns.gifts, fn g -> g.id == String.to_integer(gift_id) end)

          {:noreply,
           socket
           |> assign(:gifts, updated_gifts)
           |> put_flash(:info, gettext("Gift deleted!"))}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, gettext("Failed to delete gift"))}
      end
    else
      {:noreply, put_flash(socket, :error, gettext("Unauthorized"))}
    end
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
      <div class="mx-4 max-w-lg border border-gray-500 rounded-xl shadow-lg p-4 p-4 mt-22 mb-6">
        <h1 class="mb-6">
          {gettext("Welcome %{name}! Show people at %{party} what you want to get!",
            name: @person.name,
            party: @party.name
          )}
        </h1>

        <%= if @has_defined_gifts do %>
          <div class="border border-gray-500 p-4 rounded-xl mb-6">
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

        <div class="flex flex-col gap-4">
          <div class="border border-gray-500 p-4 rounded-xl">
            <h3>{gettext("Define what you want to get")}</h3>
            <small>{gettext("Define at least 3 presents")}</small>

            <ul class="flex flex-col gap-4 mt-5">
              <%= for gift <- @gifts do %>
                <li class="relative">
                  <textarea class="w-full textarea" disabled>{gift.name}</textarea>
                  <button
                    type="button"
                    phx-click="delete_gift"
                    phx-value-gift-id={gift.id}
                    data-confirm={gettext("Are you sure you want to delete this gift?")}
                    class="btn btn-error btn-sm absolute top-2 right-2"
                  >
                    {gettext("Delete")}
                  </button>
                </li>
              <% end %>
            </ul>

            <.form for={@gift_form} phx-submit="add_gift" class="mt-4">
              <.input
                field={@gift_form[:name]}
                type="textarea"
                label="Gift name"
                placeholder={gettext("Write down another present you would like to get")}
              />
              <.button class="btn btn-primary btn-soft w-full mt-4" type="submit">
                {gettext("Add Gift")}
              </.button>
            </.form>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
