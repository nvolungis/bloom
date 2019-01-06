defmodule Bloom.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :link, :string
      add :servings, :integer

      timestamps()
    end

  end
end
