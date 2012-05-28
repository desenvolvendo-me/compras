require 'unit_helper'
require 'app/business/price_collection_proposals_classificator_by_lot'

describe PriceCollectionProposalsClassificatorByLot do
  let :proposal_1 do
    double('proposal 1', :item_total_value_by_lot => 122)
  end

  let :proposal_2 do
    double('proposal 2', :item_total_value_by_lot => 120)
  end

  let :proposal_3 do
    double('proposal 3', :item_total_value_by_lot => 0)
  end

  let :lot do
    double(:id => 1, :price_collection_proposals => [proposal_1, proposal_2, proposal_3])
  end

  subject do
    described_class.new(lot)
  end

  it "it should return the winner proposal for lowest_price_by_lot not considering zero" do
    subject.winner_proposal.should eq proposal_2
  end
end
