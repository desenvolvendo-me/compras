class CreatePriceCollectionProposalItems < ActiveRecord::Migration
  def change
    create_table :price_collection_proposal_items do |t|
      t.references :price_collection_proposal
      t.references :price_collection_lot_item
      t.decimal :unit_price, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :price_collection_proposal_items, :price_collection_proposal_id, :name => 'pcpi_price_collection_proposal_id'
    add_index :price_collection_proposal_items, :price_collection_lot_item_id, :name => 'pcpi_price_collection_lot_item_id'

    add_foreign_key :price_collection_proposal_items, :price_collection_proposals, :name => 'pcpi_price_collection_proposal_fk'
    add_foreign_key :price_collection_proposal_items, :price_collection_lot_items, :name => 'pcpi_price_collection_lot_item_fk'
  end
end
