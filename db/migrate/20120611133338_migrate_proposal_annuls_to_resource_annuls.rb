class MigrateProposalAnnulsToResourceAnnuls < ActiveRecord::Migration
  class ResourceAnnul < ActiveRecord::Base
  end

  def change
    ResourceAnnul.find_each do |annul|
      ResourceAnnul.update_all( {:resource_id => annul.price_collection_proposal_id, :resource_type => 'PriceCollectionProposal'}, {:id => annul.id} )
    end
  end
end
