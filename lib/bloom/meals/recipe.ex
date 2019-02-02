defmodule Bloom.Meals.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bloom.Meals.{Ingredient}

  schema "recipes" do
    field :link, :string
    field :name, :string
    field :servings, :integer
    field :query, :string, virtual: true
    has_many :ingredients, Ingredient

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :link, :servings, :query])
    |> validate_required([:name, :link, :servings])
  end
end
