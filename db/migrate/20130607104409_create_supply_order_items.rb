class CreateSupplyOrderItems < ActiveRecord::Migration
  def change
    create_table :compras_supply_order_items do |t|
      t.references :supply_order
      t.references :licitation_process_ratification_item
      t.integer :authorization_quantity

      t.timestamps
    end
    add_foreign_key :compras_supply_order_items, :compras_supply_orders, column: :supply_order_id
    add_foreign_key :compras_supply_order_items, :compras_licitation_process_ratification_items,
      column: :licitation_process_ratification_item_id, name: 'cmp_lct_prc_rat_itm_ratification_item_fk'

    add_index :compras_supply_order_items, :supply_order_id
    add_index :compras_supply_order_items, :licitation_process_ratification_item_id,
      name: :index_sup_ord_itm_on_licitation_process_ratification_item_id
  end
end
