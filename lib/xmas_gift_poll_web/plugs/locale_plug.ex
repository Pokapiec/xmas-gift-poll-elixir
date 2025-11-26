defmodule XmasGiftPollWeb.Plugs.SetLocale do
  import Plug.Conn

  @locales ["en", "pl"]
  @default_locale "en"
  @session_key "locale"

  def init(opts), do: opts

  def call(conn, _opts) do
    # 1. Try to get locale from params first.
    param_locale = conn.params["locale"]

    # 2. If param is present and valid, use it and store it.
    if param_locale in @locales do
      conn
      |> put_session(@session_key, param_locale)
      |> set_gettext_locale(param_locale)
    else
      # 3. Otherwise, try session.
      session_locale = get_session(conn, @session_key)

      if session_locale in @locales do
        conn |> set_gettext_locale(session_locale)
      else
        # 4. Otherwise, use default and store it.
        conn
        |> put_session(@session_key, @default_locale)
        |> set_gettext_locale(@default_locale)
      end
    end
  end

  defp set_gettext_locale(conn, locale) do
    Gettext.put_locale(XmasGiftPollWeb.Gettext, locale)
    conn
  end
end
