defmodule Bloom.Meals.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bloom.Meals.{Recipe, IngredientNutrition}

  schema "ingredients" do
    field :name, :string
    field :quantity, :float
    field :unit, :string
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Recipe
    has_one :ingredient_nutrition, IngredientNutrition

    timestamps()
  end

  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :quantity, :unit, :delete])
    |> maybe_mark_for_deletion()
    |> validate_required([:name, :quantity, :unit])
  end

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
