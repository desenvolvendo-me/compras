class AddPurchaseProcessTradingItemToRatificationItem < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_ratification_items, :purchase_process_trading_item_id,
      :integer

    add_index :compras_licitation_process_ratification_items,
              :purchase_process_trading_item_id,
              name: :index_clpri_purchase_process_trading_item_id

    add_foreign_key :compras_licitation_process_ratification_items,
                    :compras_purchase_process_trading_items,
                    name: :clpri_purchase_process_trading_item_id_fk,
                    column: :purchase_process_trading_item_id
  end
end
