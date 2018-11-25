defmodule BureaucratDemoAppWeb.Router do
  use BureaucratDemoAppWeb, :router
  require Bureaucrat.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BureaucratDemoAppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  pipeline :admin_layout do
    plug :put_layout, {BureaucratDemoAppWeb.AdminLayoutView, "layout.html"}
  end

  scope "/admin", BureaucratDemoAppWeb.Admin, as: :admin do
    pipe_through [:browser, :admin_layout]

    Bureaucrat.Router.resources("/functions", FunctionController)
    Bureaucrat.Router.resources("/departments", DepartmentController)
    Bureaucrat.Router.resources("/employees", EmployeeController)
  end
end
