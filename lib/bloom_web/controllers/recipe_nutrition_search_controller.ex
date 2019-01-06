defmodule BloomWeb.RecipeNutritionSearchController do
  use BloomWeb, :controller

  alias Bloom.Meals

  def index(conn, %{"recipe_id" => recipe_id}) do
    recipe = Meals.get_recipe!(recipe_id)
    nutrition_search = Meals.search_recipe_nutrients(recipe)

    render(conn, "index.html", nutrition_search: nutrition_search, recipe: recipe)
  end
end
