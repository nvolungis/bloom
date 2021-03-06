defmodule BloomWeb.Router do
  use BloomWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BloomWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/recipes", RecipeController do
      resources "/nutrition-search", RecipeNutritionSearchController, only: [:index, :update]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BloomWeb do
  #   pipe_through :api
  # end
end
