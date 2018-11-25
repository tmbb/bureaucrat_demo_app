defmodule BureaucratDemoApp.Admin.Employee do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "employees" do
    field :address, :string
    field :employee_number, :integer
    field :fiscal_number, :string
    field :full_name, :string
    belongs_to :department, BureaucratDemoApp.Admin.Department, on_replace: :nilify
    belongs_to :function, BureaucratDemoApp.Admin.Function, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :address, :fiscal_number, :employee_number, :department_id, :function_id])
    |> validate_required([:full_name, :address, :fiscal_number, :employee_number])
    |> cast_assoc(:department)
    |> cast_assoc(:function)
  end

  def display(nil), do: ""
  def display(employee), do: "#{employee.full_name}"

  def select_search_field() do
    :full_name
  end
end
