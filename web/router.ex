defmodule Placex.Router do
  use Placex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Placex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:description", ImageController, :index
  end
end
