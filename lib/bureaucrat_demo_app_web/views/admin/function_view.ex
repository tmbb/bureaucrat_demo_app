defmodule BureaucratDemoAppWeb.Admin.FunctionView do
  use BureaucratDemoAppWeb, :view
  use ForageWeb.ForageView,
    routes_module: BureaucratDemoAppWeb.Router.Helpers,
    prefix: :admin_function
end
