class ChangeAuctionCreditorProposals < ActiveRecord::Migration
  def up
    rename_table :compras_auction_creditor_proposals, :compras_creditor_proposal_terms
  end

  def down
    rename_table :compras_creditor_proposal_terms, :compras_auction_creditor_proposals
  end
end
