class SetDefaultValueToUnitPriceOnPriceCollectionProposalItems < ActiveRecord::Migration
  def change
    change_column_default :compras_price_collection_proposal_items, :unit_price, 0.0
  end
end
