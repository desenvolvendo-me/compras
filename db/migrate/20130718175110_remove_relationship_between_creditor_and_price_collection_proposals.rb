class RemoveRelationshipBetweenCreditorAndPriceCollectionProposals < ActiveRecord::Migration
  def change
    remove_column :compras_price_collection_proposals, :creditor_id
  end
end
