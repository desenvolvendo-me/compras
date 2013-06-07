class CreatePurchaseProcessTradingItemNegotiations < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_trading_item_negotiations do |t|
      t.integer :purchase_process_trading_item_id
      t.integer :purchase_process_accreditation_creditor_id
      t.decimal :amount, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :compras_purchase_process_trading_item_negotiations, :purchase_process_trading_item_id,
      name: :cpptin_purchase_process_trading_item_idx
    add_index :compras_purchase_process_trading_item_negotiations, :purchase_process_accreditation_creditor_id,
      name: :cpptin_purchase_process_accreditation_creditor_idx

    add_foreign_key :compras_purchase_process_trading_item_negotiations,
      :compras_purchase_process_trading_items, column: :purchase_process_trading_item_id,
      name: :cpptin_purchase_process_trading_item_fk
    add_foreign_key :compras_purchase_process_trading_item_negotiations,
      :compras_purchase_process_accreditation_creditors, column: :purchase_process_accreditation_creditor_id,
      name: :cpptin_purchase_process_accreditation_creditor_fk
  end
end
