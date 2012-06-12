class MigrateProposalAnnulsToResourceAnnuls < ActiveRecord::Migration
  def change
    ResourceAnnul.find_each do |annul|
      annul.update_column :resource_id, annul.price_collection_proposal_id
      annul.update_column :resource_type, 'PriceCollectionProposal'
    end
  end
end
