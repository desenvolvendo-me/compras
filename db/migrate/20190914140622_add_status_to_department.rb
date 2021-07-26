class AddStatusToDepartment < ActiveRecord::Migration
  def change
    add_column :compras_departments, :status, :string
  end
end
