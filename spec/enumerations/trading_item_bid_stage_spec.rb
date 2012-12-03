# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/trading_item_bid_stage'

describe TradingItemBidStage do
  describe '.current_stage' do
    it "should returns 'proposals' when trading item be on stage of proposals" do
      stage_calculator = double(:stage_calculator)
      trading_item = double(:trading_item)

      stage_calculator.stub(:stage_of_proposals?).and_return(true)
      stage_calculator.stub(:stage_of_negotiation?).and_return(false)
      stage_calculator.stub(:stage_of_round_of_bids?).and_return(false)

      stage_calculator.should_receive(:new).with(trading_item).and_return(stage_calculator)

      expect(described_class.current_stage(trading_item, stage_calculator)).to eq described_class::PROPOSALS
    end

    it "should returns 'negotiation' when trading item be on stage of negotiation" do
      stage_calculator = double(:stage_calculator)
      trading_item = double(:trading_item)

      stage_calculator.stub(:stage_of_proposals?).and_return(false)
      stage_calculator.stub(:stage_of_negotiation?).and_return(true)
      stage_calculator.stub(:stage_of_round_of_bids?).and_return(false)

      stage_calculator.should_receive(:new).twice.with(trading_item).and_return(stage_calculator)

      expect(described_class.current_stage(trading_item, stage_calculator)).to eq described_class::NEGOTIATION
    end

    it "should returns 'round_of_bids' when trading item be on stage of round of bids" do
      stage_calculator = double(:stage_calculator)
      trading_item = double(:trading_item)

      stage_calculator.stub(:stage_of_proposals?).and_return(false)
      stage_calculator.stub(:stage_of_negotiation?).and_return(false)
      stage_calculator.stub(:stage_of_round_of_bids?).and_return(true)

      stage_calculator.should_receive(:new).twice.with(trading_item).and_return(stage_calculator)

      expect(described_class.current_stage(trading_item, stage_calculator)).to eq described_class::ROUND_OF_BIDS
    end
  end
end
