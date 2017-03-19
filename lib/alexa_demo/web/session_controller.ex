defmodule AlexaDemo.Web.SessionController do
  alias Authable.Repo
  use AlexaDemo.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case AlexaDemo.Authentication.login_by_email_and_pass(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Let's mix some colors!")
        |> redirect(to: redirect_full_path(conn))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def redirect_full_path(conn) do
    path = redirect_path(conn)
    query_params = redirect_query_params(conn)
    full_redirect_path(path, query_params)
  end

  defp redirect_path(conn), do: get_session(conn, :redirect_url) || "/"

  defp redirect_query_params(conn), do: (get_session(conn, :request_params) || %{}) |> URI.encode_query()

  defp full_redirect_path(path, ""), do: path

  defp full_redirect_path(path, query_params), do: path <> "?#{query_params}"

  def delete(conn, _) do
    conn
    |> AlexaDemo.Authentication.logout()
    |> redirect(to: session_path(conn, :new))
  end
end
