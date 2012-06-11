class MigrateProposalAnnulsToResourceAnnuls < ActiveRecord::Migration
  def change
    ResourceAnnul.find_each do |annul|
      annul.update_attributes :resource_id => annul.price_collection_proposal_id, :resource_type => 'PriceCollectionProposal'
    end
  end
end
