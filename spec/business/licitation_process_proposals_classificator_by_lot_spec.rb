require 'unit_helper'
require 'enumerate_it'
require 'app/business/licitation_process_proposals_classificator_by_lot'
require 'app/enumerations/licitation_process_type_of_calculation'

describe LicitationProcessProposalsClassificatorByLot do
  let :lot do
    double(:id => 1, :licitation_process_bidders => [bidder_1, bidder_2, bidder_3, bidder_4])
  end

  let :bidder_1 do
    double('bidder 1', :proposal_total_value_by_lot => 122)
  end

  let :bidder_2 do
    double('bidder 2', :proposal_total_value_by_lot => 120)
  end

  let :bidder_3 do
    double('bidder 3', :proposal_total_value_by_lot => 123)
  end

  let :bidder_4 do
    double('bidder 4', :proposal_total_value_by_lot => 124)
  end

  let :bidder_5 do
    double('bidder 4', :proposal_total_value_by_lot => 50)
  end

  context "lowest price by lot" do
    let :lot do
      double(:id => 1, :licitation_process_bidders => [bidder_1, bidder_2, bidder_3, bidder_4])
    end

    subject do
      described_class.new(lot, LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT)
    end

    it "it should return the winner proposal for lowest_price_by_lot" do
      subject.winner_proposals.should eq bidder_2
    end
  end

  context "sort participants by lot with more than 3 classified" do
    let :lot do
      double(:id => 1, :licitation_process_bidders => [bidder_1, bidder_2, bidder_3, bidder_4])
    end

    subject do
      described_class.new(lot, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT)
    end

    it "it should return the 4 classified proposals as winners" do
      subject.winner_proposals.should eq [bidder_2, bidder_1, bidder_3, bidder_4]
    end
  end

  context "sort participants by item with less than 3 classified" do
    let :lot do
      double(:id => 1, :licitation_process_bidders => [bidder_1, bidder_2, bidder_3, bidder_4, bidder_5])
    end

    subject do
      described_class.new(lot, LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT)
    end

    it "it should return the tree best proposals as winners" do
      subject.winner_proposals.should eq [bidder_5, bidder_2, bidder_1]
    end
  end
end
