require 'model_helper'
require 'app/models/bidder_proposal'
require 'app/models/licitation_process_ratification_item'

describe BidderProposal do
  it { should belong_to :purchase_process_item }
  it { should belong_to :bidder }

  it { should delegate(:material).to(:purchase_process_item).allowing_nil(true) }
  it { should delegate(:quantity).to(:purchase_process_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:purchase_process_item).allowing_nil(true).prefix(true) }
  it { should delegate(:reference_unit).to(:material).allowing_nil(true) }
  it { should delegate(:description).to(:material).allowing_nil(true) }
  it { should delegate(:code).to(:material).allowing_nil(true) }
  it { should delegate(:creditor).to(:bidder).allowing_nil(true) }

  it "should return total price when has unit_price and quantity" do
    subject.unit_price = 3
    subject.stub(:quantity).and_return(14)
    expect(subject.total_price).to eq 42
  end

  it "should return 0 when unit_price is 0" do
    subject.unit_price = 0
    subject.stub(:quantity).and_return(14)
    expect(subject.total_price).to eq 0
  end

  it "should return 0 when has not quantity" do
    subject.unit_price = 3
    subject.stub(:quantity).and_return(nil)
    expect(subject.total_price).to eq 0
  end

  context 'default values' do
    context 'to situation' do
      it 'situation should be by default undefined' do
        expect(subject.situation).to be SituationOfProposal::UNDEFINED
      end

      it 'situation should not be undefined when was not nil' do
        subject.situation = SituationOfProposal::WON
        subject.run_callbacks(:initialize)
        subject.situation.should_not be SituationOfProposal::UNDEFINED
      end
    end
  end

  context 'unit price greater than budget allocation unit price' do
    before do
      subject.stub(:unit_price => 10)
    end

    it 'should return false' do
      subject.stub(:purchase_process_item_unit_price => 11)

      expect(subject.unit_price_greater_than_budget_allocation_item_unit_price?).to be false
    end

    it 'should return true' do
      subject.stub(:purchase_process_item_unit_price => 9)

      expect(subject.unit_price_greater_than_budget_allocation_item_unit_price?).to be true
    end
  end
end
