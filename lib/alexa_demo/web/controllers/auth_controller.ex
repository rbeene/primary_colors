defmodule AlexaDemo.Web.AuthController do
  use AlexaDemo.Web, :controller
  alias Authable.Model.Client
  alias AlexaDemo.Repo

  plug :authenticate_user when action in [:authorize]

  def authorize(conn, params) do
    client = Repo.get!(Client, params["client_id"])

    token = Authable.GrantType.Base.create_oauth2_tokens(conn.assigns.current_user.id,
      "refresh_token", client.id, "read,write", params["redirect_uri"])

    redirect = redirect_url(token, params)

    redirect conn, external: redirect
  end

  defp redirect_url(token, params) do
    state = params["state"]
    redirect_uri = params["redirect_uri"]

    "#{redirect_uri}#state=#{state}&access_token=#{token.value}&token_type=Bearer"
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_session(:redirect_url, conn.request_path)
      |> put_session(:request_params, conn.query_params)
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

end
