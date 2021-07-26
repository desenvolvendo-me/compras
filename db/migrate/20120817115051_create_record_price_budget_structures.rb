class CreateRecordPriceBudgetStructures < ActiveRecord::Migration
  def change
    create_table :compras_record_price_budget_structures do |t|
      t.references :record_price_item
      t.references :budget_structure
      t.decimal :quantity_requested, :precision => 10, :scale => 2, :default => 0.0
      t.boolean :ride, :default => false

      t.timestamps
    end

    add_index :compras_record_price_budget_structures, :record_price_item_id, :name => :crpbs_record_price_item_id
    add_index :compras_record_price_budget_structures, :budget_structure_id, :name => :crpbs_budget_structure_id
    add_foreign_key :compras_record_price_budget_structures, :compras_record_price_items, :column => :record_price_item_id
    add_foreign_key :compras_record_price_budget_structures, :compras_budget_structures, :column => :budget_structure_id
  end
end
