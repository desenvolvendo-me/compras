class RemoveMaskedNumberFromDepartment < ActiveRecord::Migration
  def up
    remove_column :compras_departments,:masked_number
  end
end
