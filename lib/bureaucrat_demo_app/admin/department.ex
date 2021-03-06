defmodule BureaucratDemoApp.Admin.Department do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "departments" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(department, attrs) do
    department
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def display(nil), do: ""
  def display(department), do: "#{department.name}"

  def select_search_field() do
    :name
  end
end
