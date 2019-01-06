defmodule Bloom.Meals.NutrientSearch do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://api.nal.usda.gov/ndb"
  plug Tesla.Middleware.JSON, engine: Poison

  @token "5gDWokyKKg7JogI72Sawu3kRFhpUbKbFS6blyCEW"

  def for_recipe(recipe) do
    recipe.ingredients
    |> Enum.map(&(for_ingredient(&1)))
    |> Enum.map(fn(result) ->
      case result do
        {:ok, results} -> results.body
        {:error, err} -> err
      end
    end)
    |> Enum.zip(recipe.ingredients)
  end

  def for_ingredient(ingredient) do
    get("/search/?#{build_query(ingredient.name)}")
  end

  defp build_query(term) do
    URI.encode_query(%{
       format: "json",
       q: term,
       sort: "n",
       max: 10,
       offset: 0,
       api_key: @token,
       ds: "Standard Reference"
    })
  end
end

# 1 |> Bloom.Meals.get_recipe! |> Bloom.Meals.search_recipe_nutrients
