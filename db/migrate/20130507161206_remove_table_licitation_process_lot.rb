class RemoveTableLicitationProcessLot < ActiveRecord::Migration
  def change
    remove_column :compras_purchase_process_items, :licitation_process_lot_id
    drop_table :compras_licitation_process_lots
  end
end
