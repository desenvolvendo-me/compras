class AddQualificationSendDateToAuctionCreditorProposal < ActiveRecord::Migration
  def change
    add_column :compras_auction_creditor_proposals, :qualification_send_date, :date
  end
end
