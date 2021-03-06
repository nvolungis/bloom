defmodule BloomWeb.RecipeController do
  use BloomWeb, :controller

  alias Bloom.Meals
  alias Bloom.Meals.{Recipe, Ingredient}

  def index(conn, _params) do
    recipes = Meals.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Meals.change_recipe(%Recipe{ingredients: [%Ingredient{}]})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"recipe" => recipe_params}) do
    foods = recipe_params["query"]
    |> Meals.itemize_recipe()
    |> Access.get("foods")

    recipe = Meals.change_recipe(%Recipe{ingredients: Enum.map(foods, fn food -> 
      Meals.change_ingredient(%Ingredient{
        name: food["food_name"],
        quantity: food["serving_weight_grams"],
        unit: "g",
      })
    end)})

    render(conn, "new.html", changeset: recipe, foods: foods)

#     case Meals.create_recipe(recipe_params) do
#       {:ok, recipe} ->
#         conn
#         |> put_flash(:info, "Recipe created successfully.")
#         |> redirect(to: recipe_path(conn, :show, recipe))
#       {:error, %Ecto.Changeset{} = changeset} ->
#         render(conn, "new.html", changeset: changeset)
#     end
  end

  def show(conn, %{"id" => id}) do
    recipe = Meals.get_recipe!(id)
    nutrition = Meals.get_nutrition(recipe)
    render(conn, "show.html", recipe: recipe, nutrition: nutrition)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Meals.get_recipe!(id)
    changeset = Meals.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Meals.get_recipe!(id)

    case Meals.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: recipe_path(conn, :show, recipe))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Meals.get_recipe!(id)
    {:ok, _recipe} = Meals.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: recipe_path(conn, :index))
  end
end
