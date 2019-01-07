defmodule Bloom.Meals do
  import Ecto.Query, warn: false
  alias Bloom.Repo

  alias Bloom.Meals.{
    Ingredient,
    IngredientNutrition,
    NutrientAPI,
    Recipe,
  }

  def list_recipes do
    Recipe
    |> Repo.all()
    |> Repo.preload(:ingredients)
  end

  def get_recipe!(id) do
    Recipe
    |> Repo.get!(id)
    |> Repo.preload([ingredients: :ingredient_nutrition])
  end

  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:ingredients, with: &Ingredient.changeset/2)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    changeset = recipe
      |> Recipe.changeset(attrs)
      |> Ecto.Changeset.cast_assoc(:ingredients, with: &ingredient_with_assoc_changeset/2)

    changeset
    |> get_nutrition_changes()
    |> add_new_nutrition_data(changeset)

    Repo.update(changeset)
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def search_recipe_nutrition(%Recipe{} = recipe) do
    NutrientAPI.for_recipe(recipe)
  end

  def change_ingredient(%Ingredient{} = ingredient) do
    ingredient
    |> Ingredient.changeset(%{})
    |> Ecto.Changeset.cast_assoc(:ingredient_nutrition, with: &IngredientNutrition.changeset/2)
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:ingredient_nutrition, with: &IngredientNutrition.changeset/2)
    |> Repo.update()
  end

  defp ingredient_with_assoc_changeset(ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:ingredient_nutrition, with: &IngredientNutrition.changeset/2)
  end

  defp get_nutrition_changes(changeset) do
    case Ecto.Changeset.get_change(changeset, :ingredients) do
      nil -> []
      ingredients_changes ->
        Enum.map(ingredients_changes, fn ingredient_changes ->
          case Ecto.Changeset.get_change(ingredient_changes, :ingredient_nutrition) do
            nil -> nil
            nutrition_changes -> Ecto.Changeset.get_change(nutrition_changes, :ndbno)
          end
        end)
    end |> Enum.reject(&is_nil/1)
  end

  defp add_new_nutrition_data(ingredient_ndbnos, recipe_changeset) do
    ingredient_ndbnos
    |> NutrientAPI.get_reports()
    |> IO.inspect
    recipe_changeset
  end
end
