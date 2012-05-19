require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_proposals_classificator_by_item'
require 'app/enumerations/licitation_process_type_of_calculation'

describe LicitationProcessProposalsClassificatorByItem do
  let :proposal_1 do
    double('proposal 1', :total_price => 110.01, :provider => 'provider 1')
  end

  let :proposal_2 do
    double('proposal 2', :total_price => 100.0, :provider => 'provider 2')
  end

  let :proposal_3 do
    double('proposal 3', :total_price => 105.0, :provider => 'provider 3')
  end

  let :proposal_4 do
    double('proposal 4', :total_price => 104.0, :provider => 'provider 4')
  end

  let :proposal_5 do
    double('proposal 5', :total_price => 107.0, :provider => 'provider 5')
  end

  let :proposal_6 do
    double('proposal 6', :total_price => 50.0, :provider => 'provider 6')
  end

  context "lowest total price by item" do
    let :item do
      double('item', :licitation_process_bidder_proposals => [proposal_1, proposal_2, proposal_3])
    end

    subject do
      described_class.new(item, LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
    end

    it "it should return the winner proposal for lowest_total_price_by_item" do
      subject.winner_proposals.should eq proposal_2
    end
  end

  context "sort participants by item with more than 3 classified" do
    let :item do
      double('item', :licitation_process_bidder_proposals => [proposal_1, proposal_2, proposal_3, proposal_4, proposal_5])
    end

    subject do
      described_class.new(item, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM)
    end

    it "it should return the 4 classified proposals as winners" do
      subject.winner_proposals.should eq [proposal_2, proposal_4, proposal_3, proposal_5]
    end
  end

  context "sort participants by item with less than 3 classified" do
    let :item do
      double('item', :licitation_process_bidder_proposals => [proposal_1, proposal_2, proposal_3, proposal_4, proposal_6])
    end

    subject do
      described_class.new(item, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM)
    end

    it "it should return the tree best proposals as winners" do
      subject.winner_proposals.should eq [proposal_6, proposal_2, proposal_4]
    end
  end
end
