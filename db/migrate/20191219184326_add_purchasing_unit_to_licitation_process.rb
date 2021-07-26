class AddPurchasingUnitToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes,
               :purchasing_unit_id,:integer
    add_index :compras_licitation_processes, :purchasing_unit_id
    add_foreign_key :compras_licitation_processes, :compras_purchasing_units,
                    :column => :purchasing_unit_id
  end
end