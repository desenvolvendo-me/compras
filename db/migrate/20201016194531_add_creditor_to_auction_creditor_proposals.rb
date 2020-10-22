class AddCreditorToAuctionCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_auction_creditor_proposals, :creditor_id, :integer

    add_index :compras_auction_creditor_proposals, :creditor_id, name: :index_auction_creditor_proposal_on_creditor

    add_foreign_key :compras_auction_creditor_proposals, :unico_creditors, column: :creditor_id,
                    name: :auction_creditor_proposal_on_creditor_fk
  end
end
