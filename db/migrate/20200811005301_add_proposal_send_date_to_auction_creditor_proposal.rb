class AddProposalSendDateToAuctionCreditorProposal < ActiveRecord::Migration
  def change
    add_column :compras_auction_creditor_proposals, :proposal_send_date, :date
  end
end
