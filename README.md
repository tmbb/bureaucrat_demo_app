# BureaucratDemoApp

An application built using the Bureaucrat generators.

You can clone the github repo and run the application yourself to get a feeling for what's bureaucrat is capable of.
Bureaucrat should be used under Phoenix 1.4, although it *can* be used under Phoenix 1.3 if you really want.
I'll add instructions on how to run bureaucrat under Phoenix 1.3 soon.

This application models a typical organizations.
The organization has **employees**, which can have a single **function** and belong to one **department**.

It implements the typical CRUD views for these three entities.
You can add, edit or remove employees, functions or departments.
In the index view, you can apply custom search filters to the tables to focus on a subset of the data.
The index view and the select widgets (for relations) are properly paginated, so there isn't a risk of sending millions of rows to the frontend.

The application doesn't implement any kind of authentication or authorization,
but because it uses normal controllers, view and templates, you can use whatever authentication and authorization schemes you want by editing the source.

## How does it work

Bureaucrat is a very minimalist package.
It contains only the generators

# Generating this App

To generate the application yourself, follow the following steps:

1. Create a phoenix project with `mix phx.new bureaucrat_demo_app`

2. Add a dependency on `bureaucrat` and on `faker` (to build the testing database) to your `mix.exs` file:

   ```elixir
   defp deps() do
    [
      # ...
      {:bureaucrat, github: "tmbb/bureaucrat"},
      {:faker, "~> 0.11", only: :dev}
    ]
   end
   ```

3. Install the dependencies and build the npm assets:

   ```bash
    $ cd bureaucrat_demo_app
    $ mix deps.get
    $ cd assets && npm install && node node_modules/brunch/bin/brunch build
   ```

4. "Install" bureaucrat into your application.
   Run the `mix bureaucrat.install <context>` task with a given uppercase context name.
   We'll use `Admin`.

   ```bash
   $ mix bureaucrat.install Admin
   ```

5. Follow the shell instructions and add the new `:admin_layout` pipeline to your router and scope to your router.

6. Add the resources using the bureaucrat `bureaucrat.gen.html` generator, which works pretty much the same way as Phoenix's default generator:

   ```
   mix bureaucrat.gen.html Admin Department departments name:string --binary-id
   mix bureaucrat.gen.html Admin Function functions name:string --binary-id
   mix bureaucrat.gen.html Admin Employee employees full_name:string address:string fiscal_number:string employee_number:integer department_id:references:departments function_id:references:functions --binary-id
   ```

7. Add the new resources to your router, under the `Admin` scope.
   The easiest way is to `require` the `Bureaucrat.Router` module inside your
   router to be able to use the `Bureaucrat.Router.resources/2` macro.

   ```elixir
     require Bureaucrat.Router

     scope "/admin", BureaucratDemoAppWeb.Admin, as: :admin do
       pipe_through [:browser, :admin_layout]

       Bureaucrat.Router.resources("/functions", FunctionController)
       Bureaucrat.Router.resources("/departments", DepartmentController)
       Bureaucrat.Router.resources("/employees", EmployeeController)
     end
   ```

9. Add support for pagination in your Repo by `use`ing the `Paginator` module:

   ```
   defmodule BureaucratDemoApp.Repo do
      use Ecto.Repo,
        otp_app: :bureaucrat_demo_app,
        adapter: Ecto.Adapters.Postgres

      use Paginator, limit: 10
    end
   ```

8. Write a script on your `priv/repo/seeds.exs` file to add some test data to your database.
   As an example, we will use data from the [Glorious Imperium of Man](http://warhammer40k.wikia.com/wiki/Imperium_of_Man), the first galactic fascist theocracy.
   Simply add the following to your `priv/repo/seeds.exs` file:

   ```elixir
    alias BureaucratDemoApp.Admin
    alias BureaucratDemoApp.Repo

    function_names = [
      "God Emperor of Mankind",
      "Primarch",
      "Planetary Governor",
      "Techpriest",
      "Comissar",
      "Guardsman"
    ]

    department_names = [
      "Adeptus Mechanicus",
      "Astra Militarum",
      "Adeptus Astartes",
      "Ordo Xenus",
      "Ordo Malleus"
    ]

    departments =
      for name <- department_names do
        {:ok, department} = Admin.create_department(%{name: name})
        department
      end

    functions =
      for name <- function_names do
        {:ok, function} = Admin.create_function(%{name: name})
        function
      end

    employees =
      for _ <- 1..1000 do
        department = Enum.random(departments)
        function = Enum.random(functions)

        {:ok, employee} =
          %Admin.Employee{
            address: Faker.Address.En.street_address(),
            employee_number: Enum.random(1..100_000),
            fiscal_number: Faker.Gov.Us.ssn(),
            full_name: Faker.Name.name(),
            function_id: function.id,
            department_id: department.id
          }
          |> Repo.insert()

        employee
      end

   ```

9. Create your database, run the migrations and populate the tables:

   ```
   mix ecto.setup
   ```

Now you run your app and visit the urls under the `admin/` scope, i.e. `admin/employees`, `admin/functions` and `admin/departments`.

I am perfectly aware that the code above will generate several God Emperors, which is heretical, but as this is a simple example, it's probably fine.