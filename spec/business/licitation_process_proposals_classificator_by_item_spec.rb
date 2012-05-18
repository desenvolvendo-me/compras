require 'unit_helper'
require 'app/business/licitation_process_proposals_classificator_by_item'

describe LicitationProcessProposalsClassificatorByItem do
  subject do
    described_class.new(item)
  end

  let :item do
    double('item', :licitation_process_bidder_proposals => [proposal_1, proposal_2, proposal_3])
  end

  let :proposal_1 do
    double('proposal 1', :total_price => 200.0, :provider => 'provider 1')
  end

  let :proposal_2 do
    double('proposal 2', :total_price => 100.0, :provider => 'provider 2')
  end

  let :proposal_3 do
    double('proposal 3', :total_price => 300.0, :provider => 'provider 3')
  end

  it "it should return the winner proposal" do
    subject.winner_proposal.should eq proposal_2
  end

end
