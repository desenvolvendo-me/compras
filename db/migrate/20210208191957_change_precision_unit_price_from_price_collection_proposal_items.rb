class ChangePrecisionUnitPriceFromPriceCollectionProposalItems < ActiveRecord::Migration
  def change
    execute "ALTER TABLE public.compras_price_collection_proposal_items ALTER COLUMN unit_price TYPE DECIMAL(10,3)"
  end
end
