class CreateComprasSupplyOrders < ActiveRecord::Migration
  def change
    create_table :compras_supply_orders do |t|
      t.date    :authorization_date
      t.integer :creditor_id
      t.integer :licitation_process_id
    end

    add_foreign_key :compras_supply_orders, :compras_creditors,
      column: :creditor_id
    add_foreign_key :compras_supply_orders, :compras_licitation_processes,
      column: :licitation_process_id

    add_index :compras_supply_orders, :creditor_id
    add_index :compras_supply_orders, :licitation_process_id
  end
end
