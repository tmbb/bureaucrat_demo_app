defmodule BureaucratDemoAppWeb.Admin.EmployeeView do
  use BureaucratDemoAppWeb, :view
  alias BureaucratDemoApp.Admin.Department
  
  alias BureaucratDemoApp.Admin.Function
  
  use ForageWeb.ForageView,
    routes_module: BureaucratDemoAppWeb.Router.Helpers,
    prefix: :admin_employee
end
