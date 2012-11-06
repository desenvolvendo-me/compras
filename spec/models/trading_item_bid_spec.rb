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
  it { should validate_presence_of :amount }

  context "delegates" do
    let(:trading_item) { double(:trading_item) }

    before do
      subject.stub(:trading_item => trading_item)
    end

    describe "#licitation_process_id" do
      it "delegates to TradingItem#licitation_process_id" do
        trading_item.should_receive(:licitation_process_id)
        subject.licitation_process_id
      end
    end
  end

  describe "validations" do
    it "validates if amount is greater than zero" do
      should_not allow_value(0).for(:amount)
      should_not allow_value(-1).for(:amount)
      should allow_value(1).for(:amount)
    end

    it "validates if bidder is part of the trading" do
      bidder = double(:bidder, :licitation_process_id => -1)
      subject.stub(:bidder => bidder,
                   :licitation_process_id => 0)

      subject.valid?

      expect(subject.errors[:bidder]).to include "deve fazer parte do pregão presencial"
    end
  end

  describe '#update_status' do
    it 'should updates the status' do
      subject.should_receive(:update_column).with(:status, TradingItemBidStatus::WITHOUT_PROPOSAL)
      subject.update_status(TradingItemBidStatus::WITHOUT_PROPOSAL)
    end
  end
end
