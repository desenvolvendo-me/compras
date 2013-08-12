class CreateRealignmentPrices < ActiveRecord::Migration
  def change
    create_table :compras_realignment_prices, force: true do |t|
      t.integer :purchase_process_id
      t.integer :creditor_id
      t.integer :lot
    end

    add_column :compras_realignment_price_items, :realignment_price_id, :integer

    add_index :compras_realignment_prices, :purchase_process_id
    add_index :compras_realignment_prices, :creditor_id
    add_index :compras_realignment_price_items, :realignment_price_id

    add_foreign_key :compras_realignment_prices, :compras_licitation_processes,
      column: :purchase_process_id
    add_foreign_key :compras_realignment_prices, :compras_creditors,
      column: :creditor_id
    add_foreign_key :compras_realignment_price_items, :compras_realignment_prices,
      column: :realignment_price_id
  end
end
