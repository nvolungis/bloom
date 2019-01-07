defmodule Bloom.Repo.Migrations.CreateIngredientNutrition do
  use Ecto.Migration

  def change do
    create table(:ingredient_nutrition) do
      add :ndbno, :string
      add :kcal, :float
      add :ingredient_id, references(:ingredients, on_delete: :delete_all)

      timestamps()
    end

    create index(:ingredient_nutrition, [:ingredient_id])
  end
end
