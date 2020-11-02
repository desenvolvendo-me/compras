class AddRestartDisputeToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :restart_dispute_date, :date
    add_column :compras_auctions, :restart_dispute_time, :time
  end
end
