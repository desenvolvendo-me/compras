class AddStatusToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :status, :string
  end
end
