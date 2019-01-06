defmodule Bloom.MealsTest do
  use Bloom.DataCase

  alias Bloom.Meals

  describe "recipes" do
    alias Bloom.Meals.Recipe

    @valid_attrs %{link: "some link", name: "some name", servings: 42}
    @update_attrs %{link: "some updated link", name: "some updated name", servings: 43}
    @invalid_attrs %{link: nil, name: nil, servings: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Meals.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Meals.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Meals.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Meals.create_recipe(@valid_attrs)
      assert recipe.link == "some link"
      assert recipe.name == "some name"
      assert recipe.servings == 42
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meals.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, recipe} = Meals.update_recipe(recipe, @update_attrs)
      assert %Recipe{} = recipe
      assert recipe.link == "some updated link"
      assert recipe.name == "some updated name"
      assert recipe.servings == 43
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Meals.update_recipe(recipe, @invalid_attrs)
      assert recipe == Meals.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Meals.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Meals.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Meals.change_recipe(recipe)
    end
  end
end
