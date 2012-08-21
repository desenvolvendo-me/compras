class CreateRecordPriceItems < ActiveRecord::Migration
  def change
    create_table :compras_record_price_items do |t|
      t.references :record_price
      t.references :administrative_process_budget_allocation_item

      t.timestamps
    end

    add_index :compras_record_price_items, :record_price_id
    add_index :compras_record_price_items, :administrative_process_budget_allocation_item_id, :name => :crpi_administrative_process_budget_allocation_item_id
    add_foreign_key :compras_record_price_items, :compras_record_prices, :column => :record_price_id
    add_foreign_key :compras_record_price_items, :compras_administrative_process_budget_allocation_items, :name => :crpi_administrative_process_budget_allocation_item_id_fk, :column => :administrative_process_budget_allocation_item_id
  end
end
