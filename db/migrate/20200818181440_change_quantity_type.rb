class ChangeQuantityType < ActiveRecord::Migration
  def up
    remove_column :compras_auction_creditor_proposal_items, :quantity
    add_column :compras_auction_creditor_proposal_items, :quantity, :decimal, precision: 10, scale: 2
  end

  def down
    remove_column :compras_auction_creditor_proposal_items, :quantity
    add_column :compras_auction_creditor_proposal_items, :quantity, :integer
  end
end
