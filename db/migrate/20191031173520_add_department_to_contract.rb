class AddDepartmentToContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :department_id, :integer
  end
end
