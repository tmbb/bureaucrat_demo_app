defmodule BureaucratDemoAppWeb."Admin".EmployeeControllerTest do
  use BureaucratDemoAppWeb.ConnCase

  alias BureaucratDemoApp.Admin

  @create_attrs %{address: "some address", employee_number: 42, fiscal_number: "some fiscal_number", full_name: "some full_name"}
  @update_attrs %{address: "some updated address", employee_number: 43, fiscal_number: "some updated fiscal_number", full_name: "some updated full_name"}
  @invalid_attrs %{address: nil, employee_number: nil, fiscal_number: nil, full_name: nil}

  def fixture(:employee) do
    {:ok, employee} = Admin.create_employee(@create_attrs)
    employee
  end

  describe "index" do
    test "lists all employees", %{conn: conn} do
      conn = get conn, Routes.admin_employee_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Employees"
    end
  end

  describe "new employee" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.admin_employee_path(conn, :new)
      assert html_response(conn, 200) =~ "New Employee"
    end
  end

  describe "create employee" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.admin_employee_path(conn, :create), employee: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_employee_path(conn, :show, id)

      conn = get conn, Routes.admin_employee_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Employee"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.admin_employee_path(conn, :create), employee: @invalid_attrs
      assert html_response(conn, 200) =~ "New Employee"
    end
  end

  describe "edit employee" do
    setup [:create_employee]

    test "renders form for editing chosen employee", %{conn: conn, employee: employee} do
      conn = get conn, Routes.admin_employee_path(conn, :edit, employee)
      assert html_response(conn, 200) =~ "Edit Employee"
    end
  end

  describe "update employee" do
    setup [:create_employee]

    test "redirects when data is valid", %{conn: conn, employee: employee} do
      conn = put conn, Routes.admin_employee_path(conn, :update, employee), employee: @update_attrs
      assert redirected_to(conn) == Routes.admin_employee_path(conn, :show, employee)

      conn = get conn, Routes.admin_employee_path(conn, :show, employee)
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, employee: employee} do
      conn = put conn, Routes.admin_employee_path(conn, :update, employee), employee: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Employee"
    end
  end

  describe "delete employee" do
    setup [:create_employee]

    test "deletes chosen employee", %{conn: conn, employee: employee} do
      conn = delete conn, Routes.admin_employee_path(conn, :delete, employee)
      assert redirected_to(conn) == Routes.admin_employee_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.admin_employee_path(conn, :show, employee)
      end
    end
  end

  defp create_employee(_) do
    employee = fixture(:employee)
    {:ok, employee: employee}
  end
end
