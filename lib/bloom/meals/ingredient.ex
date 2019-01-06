defmodule Bloom.Meals.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bloom.Meals.{Recipe}

  schema "ingredients" do
    field :name, :string
    field :quantity, :float
    field :unit, :string
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Recipe

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    IO.inspect("CHANGING")
    ingredient
    |> cast(attrs, [:name, :quantity, :unit, :delete])
    |> maybe_mark_for_deletion()
    |> IO.inspect()
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
