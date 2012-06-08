class MakeAllProposalsActivesByDefault < ActiveRecord::Migration
  def change
    PriceCollectionProposal.find_each do |proposal|
      proposal.status = PriceCollectionProposalStatus::ACTIVE
      proposal.save!
    end
  end
end
