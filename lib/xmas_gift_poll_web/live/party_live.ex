defmodule XmasGiftPollWeb.PartyLive.New do
  use XmasGiftPollWeb, :live_view
  alias XmasGiftPoll.Events

  def mount(_, _, socket) do
    changeset = Events.change_party(%Events.Party{})
    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"party" => party_params}, socket) do
    case Events.create_party(party_params) do
      {:ok, party} ->
        {:noreply,
         socket
         |> redirect(to: ~p"/parties/#{party.public_id}/people/new")}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-lg">
      <h1>Create Party</h1>

      <.form for={@form} phx-submit="save">
        <.input field={@form[:name]} type="text" label="Party name" />
        <.button type="submit">Save</.button>
      </.form>
    </div>
    """
  end
end
