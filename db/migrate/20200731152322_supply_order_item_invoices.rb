class SupplyOrderItemInvoices < ActiveRecord::Migration
  def change
    create_table :compras_supply_order_item_invoices do |t|
      t.integer  "supply_order_item_id"
      t.integer  "invoice_id"
      t.integer  "quantity_supplied"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index :compras_supply_order_item_invoices, :supply_order_item_id, :name => :csoii_supply_order_item_index
    add_index :compras_supply_order_item_invoices, :invoice_id, :name => :csoii_invoice_index

    add_foreign_key :compras_supply_order_item_invoices, :compras_invoices, :column => :invoice_id,
                    :name => :csoii_invoice_fk
    add_foreign_key :compras_supply_order_item_invoices, :compras_supply_order_items, :column => :supply_order_item_id,
                    :name => :csoii_supply_order_item_fk
  end

end
