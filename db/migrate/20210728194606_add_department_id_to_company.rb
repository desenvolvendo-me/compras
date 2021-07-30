class AddDepartmentIdToCompany < ActiveRecord::Migration
  def change
    add_column :unico_companies, :department_id, :integer
  end
end