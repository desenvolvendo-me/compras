class RemovePriceCollectionIdFromResourceAnnul < ActiveRecord::Migration
  def change
    remove_column :resource_annuls, :price_collection_proposal_id
  end
end
