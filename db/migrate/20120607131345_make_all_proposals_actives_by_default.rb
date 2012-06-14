class MakeAllProposalsActivesByDefault < ActiveRecord::Migration
  class PriceCollectionProposal < ActiveRecord::Base
  end

  def change
    PriceCollectionProposal.find_each do |proposal|
      proposal.status = PriceCollectionProposalStatus::ACTIVE
      proposal.save!
    end
  end
end
