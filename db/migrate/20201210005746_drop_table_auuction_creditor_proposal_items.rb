class DropTableAuuctionCreditorProposalItems < ActiveRecord::Migration
  def change
    drop_table :compras_auction_creditor_proposal_items
  end
end
