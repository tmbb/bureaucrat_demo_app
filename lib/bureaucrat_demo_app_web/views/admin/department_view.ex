defmodule BureaucratDemoAppWeb.Admin.DepartmentView do
  use BureaucratDemoAppWeb, :view
  use ForageWeb.ForageView,
    routes_module: BureaucratDemoAppWeb.Router.Helpers,
    prefix: :admin_department
end
