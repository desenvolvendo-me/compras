class AddFailedToPurchaseProcessTradingItems < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_trading_items, :status, :string,
      default: 'pending'
  end
end
