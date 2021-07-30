class AddDepartmentToCompany < ActiveRecord::Migration
  def change
    add_column :unico_companies, :department, :string
    add_foreign_key :unico_companies, :compras_departments, column: :description, primary_key: :id

    add_index :unico_companies, :department
  end
end