class AddEndDisputeToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :end_dispute_date, :date
    add_column :compras_auctions, :end_dispute_time, :time
  end
end
