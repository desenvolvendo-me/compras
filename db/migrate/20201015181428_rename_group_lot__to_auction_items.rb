class RenameGroupLotToAuctionItems < ActiveRecord::Migration
  def up
    rename_column :compras_auction_items, :group_lot, :lot
  end

  def down
    rename_column :compras_auction_items, :lot, :group_lot
  end
end
