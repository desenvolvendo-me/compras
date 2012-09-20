require 'model_helper'
require 'app/models/price_registration_item'
require 'app/models/price_registration_budget_structure'

describe PriceRegistrationItem do
  it { should belong_to :price_registration }
  it { should belong_to :administrative_process_budget_allocation_item }

  it { should have_many(:price_registration_budget_structures).dependent(:destroy) }

  it { should validate_presence_of :price_registration }
  it { should validate_presence_of :administrative_process_budget_allocation_item }

  context "with material" do
    let :administrative_process_budget_allocation_item do
      double :to_s => 'Cadeira'
    end

    it 'should administrative_process_budget_allocation_item response as to_s' do
      subject.stub(:administrative_process_budget_allocation_item).and_return(administrative_process_budget_allocation_item)

      expect(subject.to_s).to eq 'Cadeira'
    end
  end

  context '#unit_price' do
    it 'delegates the unit price to the winning bid' do
      licitation_process_classification = double(:winning_bid, :unit_value => 10.5)
      subject.stub(:winning_bid).and_return(licitation_process_classification)

      expect(subject.unit_price).to eq 10.5
    end

    it 'returns nil if bids were not classified yet' do
      subject.stub(:winning_bid => nil)

      expect(subject.unit_price).to be_nil
    end
  end

  context '#winning_bid' do
    it 'returns the winning bid of the licitation process if type of calculation is "lowest_global_price"' do
      licitation_process = double(:licitation_process)
      subject.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_GLOBAL_PRICE)
      subject.stub(:licitation_process).and_return(licitation_process)

      licitation_process.should_receive(:winning_bid)

      subject.winning_bid
    end

    it 'returns the winning bid of the licitation process item if type of calculation is "lowest_total_price_by_item"' do 
      administrative_process_item = double(:administrative_process_item)
      subject.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM)
      subject.stub(:administrative_process_budget_allocation_item => administrative_process_item)

      administrative_process_item.should_receive(:winning_bid)

      subject.winning_bid
    end

    it 'returns the winning bid of the batch of items if type of calculation is "lowest_price_by_lot"' do
      licitation_process_lot = double(:administrative_process_lot)
      subject.stub(:licitation_process_lot => licitation_process_lot)
      subject.stub(:type_of_calculation => PriceCollectionTypeOfCalculation::LOWEST_PRICE_BY_LOT)

      licitation_process_lot.should_receive(:winning_bid)

      subject.winning_bid
    end
  end

  context '#winning_bidder' do
    it 'returns the bidder that placed the winning bid' do
      winning_bid = double(:winning_bid)
      subject.stub(:winning_bid).and_return(winning_bid)

      winning_bid.should_receive(:bidder)
      subject.winning_bidder
    end

    it 'returns nil if bids were not classified yet' do
      subject.stub(:winning_bid => nil)

      expect(subject.winning_bidder).to be_nil
    end
  end

  context '#balance' do
    it "returns the total licitiation process quantity minus the quantity purchased with direct purchases" do
      subject.stub(:quantity => 20)
      subject.purchased_quantity = 10

      expect(subject.balance).to eq 10
    end
  end
end
