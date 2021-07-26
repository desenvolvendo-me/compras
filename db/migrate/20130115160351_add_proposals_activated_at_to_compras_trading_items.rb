class AddProposalsActivatedAtToComprasTradingItems < ActiveRecord::Migration
  def change
    add_column :compras_trading_items, :proposals_activated_at, :datetime
  end
end
