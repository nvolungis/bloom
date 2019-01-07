defmodule BloomWeb.RecipeNutritionSearchView do
  use BloomWeb, :view

  def ingredient_title(nutrition_search, index) do
    {_search_results, ingredient} = Enum.at(nutrition_search, index)
    ingredient.name
  end

  def search_options(nutrition_search, index) do
    {search_results, _} = Enum.at(nutrition_search, index)
    search_results["list"]["item"]
  end
end
