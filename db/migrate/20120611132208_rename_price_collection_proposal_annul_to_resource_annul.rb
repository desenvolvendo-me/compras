class RenamePriceCollectionProposalAnnulToResourceAnnul < ActiveRecord::Migration
  def change
    rename_table :price_collection_proposal_annuls, :resource_annuls
  end
end
