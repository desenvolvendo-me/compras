require 'unit_helper'
require 'app/business/price_collection_proposals_classificator_by_item'

describe PriceCollectionProposalsClassificatorByItem do
  let :proposal_1 do
    double('proposal 1', :total_price => 100.0)
  end

  let :proposal_2 do
    double('proposal 2', :total_price => 50.0)
  end

  let :proposal_3 do
    double('proposal 3', :total_price => 0.0)
  end

  let :item do
    double('item', :price_collection_proposal_items => [proposal_1, proposal_2, proposal_3])
  end

  subject do
    described_class.new(item)
  end

  it "it should return the winner proposal for lowest_total_price_by_item not considering zero" do
    subject.winner_proposal.should eq proposal_2
  end
end
