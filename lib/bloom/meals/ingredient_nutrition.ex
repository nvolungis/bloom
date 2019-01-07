defmodule Bloom.Meals.IngredientNutrition do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bloom.Meals.{Ingredient}


  schema "ingredient_nutrition" do
    field :kcal, :float
    field :ndbno, :string
    belongs_to :ingredient, Ingredient

    timestamps()
  end

  @doc false
  def changeset(ingredient_nutrition, attrs) do
    ingredient_nutrition
    |> cast(attrs, [:ndbno, :kcal])
    # |> validate_required([:ndbno, :kcal])
  end
end
