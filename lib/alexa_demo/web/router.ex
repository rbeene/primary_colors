defmodule AlexaDemo.Web.Router do
  use AlexaDemo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AlexaDemo.Authentication, repo: AlexaDemo.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", AlexaDemo do
    pipe_through :api

    post "/alexa", AlexaController, :create
  end

  scope "/", AlexaDemo.Web do
    pipe_through :browser # Use the default browser stack

    get "/oauth/authorize", AuthController, :authorize
    resources "/users", UserController, only: [:index, :new, :show, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/clients", ClientController, except: [:delete]
  end

end
