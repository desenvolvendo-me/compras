class AddDepartmentToCompany < ActiveRecord::Migration
  def change
    add_column :unico_companies, :department, :string
  end
end

