defmodule BloomWeb.RecipeNutritionSearchController do
  use BloomWeb, :controller

  alias Bloom.Meals
  alias Bloom.Meals.{Ingredient, IngredientNutrition, Recipe}

  def index(conn, %{"recipe_id" => recipe_id}) do
    recipe = Meals.get_recipe!(recipe_id)
    nutrition_search = Meals.search_recipe_nutrition(recipe)
    changeset = Meals.change_recipe(recipe)

    render(conn, "index.html",
      nutrition_search: nutrition_search,
      recipe: recipe,
      changeset: changeset
    )
  end
end
