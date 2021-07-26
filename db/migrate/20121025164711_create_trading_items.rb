class CreateTradingItems < ActiveRecord::Migration
  def change
    create_table :compras_trading_items do |t|
      t.references :trading
      t.references :administrative_process_budget_allocation_item
      t.decimal :minimum_reduction_percent
      t.decimal :minimum_reduction_value
      t.text :detailed_description

      t.timestamps
    end
    add_index :compras_trading_items, :trading_id
    add_index :compras_trading_items, :administrative_process_budget_allocation_item_id,
              :name => :index_capbai_trading_items

    add_foreign_key :compras_trading_items, :compras_tradings, :column => :trading_id
    add_foreign_key :compras_trading_items, :compras_administrative_process_budget_allocation_items,
                    :column => :administrative_process_budget_allocation_item_id,
                    :name => :fk_trading_items_capbai
  end
end
