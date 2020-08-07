class CreateTableAuctionCreditorProposal < ActiveRecord::Migration
  def change
    create_table :compras_auction_creditor_proposals do |t|
      t.integer :auction_id
      t.integer :user_id
      t.boolean :term
      t.boolean :impediment
      t.boolean :proposal_independent
      t.boolean :art_5
      t.boolean :art_93_pcd
      t.boolean :art_529_clt
      t.string  :proposal_doc
      t.string  :proposal_qualification_doc
    end

    add_index :compras_auction_creditor_proposals, :auction_id
    add_index :compras_auction_creditor_proposals, :user_id

    add_foreign_key :compras_auction_creditor_proposals, :compras_auctions,
                    column: :auction_id, name: :creditor_proposal_auction_id_fk

    add_foreign_key :compras_auction_creditor_proposals, :compras_users,
                    column: :user_id, name: :creditor_proposal_user_fk
  end
end
