class AddPurchasingUnitToDemand < ActiveRecord::Migration
  def change
    add_column :compras_demands,
               :purchasing_unit_id, :integer
    add_index :compras_demands, :purchasing_unit_id
    add_foreign_key :compras_demands, :compras_purchasing_units,
                    :column => :purchasing_unit_id
  end
end
