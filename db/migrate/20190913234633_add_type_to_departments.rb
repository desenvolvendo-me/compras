class AddTypeToDepartments < ActiveRecord::Migration
  def change
    add_column :compras_departments, :type, :string
  end
end
