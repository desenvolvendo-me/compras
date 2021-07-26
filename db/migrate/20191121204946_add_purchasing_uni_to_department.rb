class AddPurchasingUniToDepartment < ActiveRecord::Migration
  def change
    add_column :compras_departments,
               :purchasing_unit_id, :integer
    add_index :compras_departments, :purchasing_unit_id
    add_foreign_key :compras_departments, :compras_purchasing_units,
                    :column => :purchasing_unit_id
  end
end
