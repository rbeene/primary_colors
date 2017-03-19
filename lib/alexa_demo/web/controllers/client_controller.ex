defmodule AlexaDemo.Web.ClientController do
  use AlexaDemo.Web, :controller

  alias AlexaDemo.Repo
  alias Authable.Model.Client

  def index(conn, _params) do
    clients = Repo.all(Client)
    render conn, "index.html", clients: clients
  end

  def new(conn, _params) do
    changeset = Client.changeset(%Client{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"client" => client_params}) do
    client_params = Map.put(client_params, "user_id",
                      conn.assigns[:current_user].id)
    changeset = Client.changeset(%Client{}, client_params)
    case Repo.insert(changeset) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "#{client.name} created!")
        |> redirect(to: client_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client = Repo.get(Client, id)
    render conn, "show.html", client: client
  end

end
