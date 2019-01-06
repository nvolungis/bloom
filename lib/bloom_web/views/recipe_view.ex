defmodule BloomWeb.RecipeView do
  use BloomWeb, :view

  alias Bloom.Meals
  alias Bloom.Meals.{Recipe, Ingredient}

  def link_to_ingredient_fields do
    changeset = Meals.change_recipe(%Recipe{ingredients: [%Ingredient{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "_ingredient_fields.html", f: form)
    link "Add Ingredient", to: "#", "data-template": fields, id: "add_ingredient"
  end
end
