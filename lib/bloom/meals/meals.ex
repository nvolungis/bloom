defmodule Bloom.Meals do
  import Ecto.Query, warn: false
  alias Bloom.Repo

  alias Bloom.Meals.{Recipe, Ingredient, NutrientSearch}

  def list_recipes do
    Recipe
    |> Repo.all()
    |> Repo.preload(:ingredients)
  end

  def get_recipe!(id) do
    Recipe
    |> Repo.get!(id)
    |> Repo.preload(:ingredients)
  end

  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:ingredients, with: &Ingredient.changeset/2)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:ingredients, with: &Ingredient.changeset/2)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  def search_recipe_nutrients(%Recipe{} = recipe) do
    NutrientSearch.for_recipe(recipe)
  end
end
