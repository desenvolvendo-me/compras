class RemovePriceCollectionLotItemFromPriceCollectionProposalItems < ActiveRecord::Migration
  def change
    remove_column :compras_price_collection_proposal_items, :price_collection_lot_item_id

    add_column :compras_price_collection_proposal_items, :price_collection_item_id, :integer

    add_foreign_key :compras_price_collection_proposal_items, :compras_price_collection_items,
      column: :price_collection_item_id, name: :cpcpi_price_collection_item_id_fk

    add_index :compras_price_collection_proposal_items, :price_collection_item_id,
      name: :index_cpcpi_price_collection_item_id
  end
end
