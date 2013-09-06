class RemoveLicitationProcessRatificationItemFromSupplyOrderItems < ActiveRecord::Migration
  def change
    remove_column :compras_supply_order_items, :licitation_process_ratification_item_id

    add_column :compras_supply_order_items, :pledge_item_id, :integer

    add_index :compras_supply_order_items, :pledge_item_id
  end
end
