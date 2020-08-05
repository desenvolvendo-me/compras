class CreateTableAuctionCreditorProposals < ActiveRecord::Migration
  def change
    create_table :compras_auction_creditor_proposal_items do |t|
      t.integer :auction_creditor_proposal_id
      t.integer :auction_item_id
      t.string  :manufacturer
      t.string  :model_version
      t.integer :quantity
      t.text    :description
      t.decimal :unit_price, precision: 16, scale: 2
      t.decimal :global_price, precision: 16, scale: 2
    end

    add_index :compras_auction_creditor_proposal_items, :auction_creditor_proposal_id, name: :creditor_proposals_index
    add_index :compras_auction_creditor_proposal_items, :auction_item_id, name: :auction_items_index

    add_foreign_key :compras_auction_creditor_proposal_items, :compras_auction_creditor_proposals,
                    column: :auction_creditor_proposal_id, name: :auction_creditor_proposals_fk

    add_foreign_key :compras_auction_creditor_proposal_items, :compras_auction_items,
                    column: :auction_item_id, name: :auction_items_proposals_fk
  end
end
