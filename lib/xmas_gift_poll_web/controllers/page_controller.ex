defmodule XmasGiftPollWeb.PageController do
  use XmasGiftPollWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
