# Populate the database with the data collected by the techpriests
# on the Glorious Imperium of Man

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
