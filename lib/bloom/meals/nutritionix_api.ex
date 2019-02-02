defmodule Bloom.Meals.NutritionixAPI do
  use Tesla
  plug Tesla.Middleware.BaseUrl, "https://trackapi.nutritionix.com"
  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Headers, [
    {"x-app-id", "c9406387"},
    {"x-app-key", "7c9b5af13976ebfe2204e80d55bf7210"}
  ]

  def search text do
    post("/v2/natural/nutrients", %{query: text}) |> IO.inspect
  end
end
