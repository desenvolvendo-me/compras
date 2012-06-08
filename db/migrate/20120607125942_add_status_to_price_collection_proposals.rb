class AddStatusToPriceCollectionProposals < ActiveRecord::Migration
  def change
    add_column :price_collection_proposals, :status, :string
  end
end
