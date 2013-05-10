class CreatePurchaseProcessTradingBids < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_trading_bids do |t|
      t.integer :purchase_process_trading_id, null: false
      t.integer :purchase_process_accreditation_creditor_id, null: false
      t.integer :purchase_process_item_id, null: false
      t.integer :round, null: false
      t.integer :number
      t.integer :lot
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0.0
      t.string  :status, null: false
      t.text    :disqualification_reason
      t.timestamps
    end

    add_index :compras_purchase_process_trading_bids, :purchase_process_trading_id, name: :cpptb_purchase_process_trading_id
    add_index :compras_purchase_process_trading_bids, :purchase_process_accreditation_creditor_id, name: :cpptb_accreditation_creditor_idx
    add_index :compras_purchase_process_trading_bids, :purchase_process_item_id, name: :cpptb_purchase_process_item_idx

    add_foreign_key :compras_purchase_process_trading_bids, :compras_purchase_process_tradings, column: :purchase_process_trading_id, name: :cpptb_purchase_process_tading_fk
    add_foreign_key :compras_purchase_process_trading_bids, :compras_purchase_process_accreditation_creditors, column: :purchase_process_accreditation_creditor_id, name: :cpptb_accreditation_creditor_fk
    add_foreign_key :compras_purchase_process_trading_bids, :compras_purchase_process_items, column: :purchase_process_item_id, name: :cpptb_purchase_process_item_fk
  end
end
