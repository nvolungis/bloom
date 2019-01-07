defmodule Bloom.Meals.NutrientAPI do
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
    get("/search/?#{build_search_query(ingredient.name)}")
  end

  def get_reports(ndbnos) do
    case get("/V2/reports?#{build_report_query(ndbnos)}") do
      {:ok, resp} -> resp.body["foods"]
      {:error, error} ->
        IO.inspect(error)
        nil
    end
  end

  defp build_search_query(term) do
    URI.encode_query(%{
      format: "json",
      q: term,
      sort: "n",
      max: 20,
      offset: 0,
      api_key: @token,
      ds: "Standard Reference"
    })
  end

  defp build_report_query(ndbnos) do
    ndbnos_params = ndbnos
      |> Enum.map(&("ndbno=#{&1}"))
      |> Enum.join("&")

    URI.encode_query(%{
      format: "json",
      type: "f",
      api_key: @token,
    }) <> "&" <> ndbnos_params
  end
end

# 1 |> Bloom.Meals.get_recipe! |> Bloom.Meals.search_recipe_nutrients
