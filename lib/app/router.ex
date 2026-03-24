defmodule App.Router do
  use Quark.Router

  get("/", to: App.Controllers.SampleController, action: :index)
  get("/hello", to: App.Controllers.SampleController, action: :hello)

  fallback_routes()
end
