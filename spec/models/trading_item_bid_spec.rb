#encoding: utf-8
require 'model_helper'
require 'app/models/trading_item_bid'

describe TradingItemBid do

  it { should belong_to :trading_item }
  it { should belong_to :bidder }

  it { should have_one(:trading).through(:trading_item) }

  it { should validate_presence_of :round }
  it { should validate_presence_of :trading_item }
  it { should validate_presence_of :bidder }
  it { should validate_presence_of :status }

  it { should delegate(:licitation_process_id).to(:trading_item) }
  it { should delegate(:minimum_reduction_percent).to(:trading_item) }
  it { should delegate(:minimum_reduction_percent?).to(:trading_item) }
  it { should delegate(:minimum_reduction_value).to(:trading_item) }
  it { should delegate(:minimum_reduction_value?).to(:trading_item) }
  it { should delegate(:last_proposal_value).to(:trading_item).prefix(true) }

  describe "validations" do
    it "validates if amount is greater than zero when status is with_proposal" do
      subject.stub(:with_proposal?).and_return(true)

      should_not allow_value(0).for(:amount)
      should_not allow_value(-1).for(:amount)
      should allow_value(1).for(:amount)
    end

    it "does not validate if amount is greater than zero when status is not with_proposal" do
      subject.stub(:with_proposal?).and_return(false)

      should allow_value(0).for(:amount)
      should allow_value(-1).for(:amount)
      should allow_value(1).for(:amount)
    end

    it 'validates presence of amount when status is with_proposal' do
      subject.stub(:with_proposal?).and_return(true)

      should validate_presence_of :amount
    end

    it 'does not validate presence of amount when status is not with_proposal' do
      subject.stub(:with_proposal?).and_return(false)

      should_not validate_presence_of :amount
    end

    it "validates if bidder is part of the trading" do
      bidder = double(:bidder, :licitation_process_id => -1)
      subject.stub(:bidder => bidder,
                   :licitation_process_id => 0)

      subject.valid?

      expect(subject.errors[:bidder]).to include "deve fazer parte do pregão presencial"
    end

    it 'validates if amount is greather than minimum reduction value' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_value).and_return(2.3)
      subject.stub(:minimum_reduction_value?).and_return(true)
      subject.stub(:trading_item_last_proposal_value).and_return(10.0)

      subject.amount = 11.0

      subject.valid?

      expect(subject.errors[:amount]).to include 'deve ser menor ou igual a 7,70'
    end

    it 'does not validate if amount is greather than minimum reduction value when is not with_proposal' do
      subject.stub(:with_proposal?).and_return(false)
      subject.stub(:minimum_reduction_value).and_return(2.3)
      subject.stub(:minimum_reduction_value?).and_return(true)
      subject.stub(:trading_item_last_proposal_value).and_return(10.0)

      subject.amount = 11.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end

    it 'does not validate if amount is greather than minimum reduction value when not minimum reduction value' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_value).and_return(2.3)
      subject.stub(:minimum_reduction_value?).and_return(false)
      subject.stub(:trading_item_last_proposal_value).and_return(10.0)

      subject.amount = 11.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end

    it 'does not validate if amount is greather than minimum reduction value when has no one proposal' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_value).and_return(2.3)
      subject.stub(:minimum_reduction_value?).and_return(true)
      subject.stub(:trading_item_last_proposal_value).and_return(0.0)

      subject.amount = 11.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end

    it 'validates if amount is greather than minimum reduction percentage' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_percent).and_return(10)
      subject.stub(:minimum_reduction_percent?).and_return(true)
      subject.stub(:trading_item_last_proposal_value).and_return(100.0)

      subject.amount = 95.0

      subject.valid?

      expect(subject.errors[:amount]).to include 'deve ser menor ou igual a 90,00'
    end

    it 'does not validate if amount is greather than minimum reduction percentage when is not with_proposal' do
      subject.stub(:with_proposal?).and_return(false)
      subject.stub(:minimum_reduction_percent).and_return(10)
      subject.stub(:minimum_reduction_percent?).and_return(true)
      subject.stub(:trading_item_last_proposal_value).and_return(100.0)

      subject.amount = 95.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end

    it 'does not validate if amount is greather than minimum reduction percentage when not minimum reduction value' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_percent).and_return(10)
      subject.stub(:minimum_reduction_percent?).and_return(false)
      subject.stub(:trading_item_last_proposal_value).and_return(100.0)

      subject.amount = 95.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end

    it 'does not validate if amount is greather than minimum reduction percentage when has no one proposal' do
      subject.stub(:with_proposal?).and_return(true)
      subject.stub(:minimum_reduction_percent).and_return(10)
      subject.stub(:minimum_reduction_percent?).and_return(false)
      subject.stub(:trading_item_last_proposal_value).and_return(0.0)

      subject.amount = 95.0

      subject.valid?

      expect(subject.errors[:amount]).to eq []
    end
  end

  describe '#update_status' do
    it 'should updates the status' do
      subject.should_receive(:update_column).with(:status, TradingItemBidStatus::WITHOUT_PROPOSAL)
      subject.update_status(TradingItemBidStatus::WITHOUT_PROPOSAL)
    end
  end
end
