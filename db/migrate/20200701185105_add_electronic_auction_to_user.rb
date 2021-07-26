class AddElectronicAuctionToUser < ActiveRecord::Migration
  def change
    add_column :compras_users, :electronic_auction, :boolean
  end
end
