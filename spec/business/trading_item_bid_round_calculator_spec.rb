require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/trading_item_bid_round_calculator'

describe TradingItemBidRoundCalculator do
  subject do
    described_class.new(trading_item, stage_calculator, trading_item_bidders)
  end

  let(:trading_item) { double(:trading_item) }
  let(:stage_calculator) { double(:stage_calculator) }
  let(:trading_item_bidders) { double(:trading_item_bidders) }

  describe 'delegates' do
    it 'delegates trading_item_bids to trading_item' do
      trading_item.should_receive(:trading_item_bids)

      subject.trading_item_bids
    end

    it 'delegates selected_bidders_at_proposals to trading_item' do
      trading_item.should_receive(:selected_bidders_at_proposals)

      subject.selected_bidders_at_proposals
    end
  end

  describe '#calculate' do
    context "when there are no bids" do

      before { subject.stub(:trading_item_bids_for_stage_of_round_of_bids).and_return([]) }

      it 'should return 1' do
        stage_calculator.should_receive(:new).with(trading_item).
          and_return(stage_calculator)
        stage_calculator.should_receive(:stage_of_round_of_bids?).and_return(true)

        expect(subject.calculate).to eq 1
      end

      it 'should return 0 when is not on stage of round of bids' do
        stage_calculator.should_receive(:new).with(trading_item).
          and_return(stage_calculator)
        stage_calculator.should_receive(:stage_of_round_of_bids?).and_return(false)

        expect(subject.calculate).to eq 0
      end
    end

    it 'should return current_round when not all bidders have proposals' do
      last_bid = double(:last_bid, :round => 2)

      subject.should_receive(:last_bid).twice.and_return(last_bid)
      subject.should_receive(:all_bidders_have_bid_for_last_round?).
              and_return(false)

      expect(subject.calculate).to eq 2
    end

    it 'should return next_round when all bidders have proposals' do
      last_bid = double(:last_bid, :round => 2)

      subject.should_receive(:last_bid).twice.and_return(last_bid)
      stage_calculator.should_receive(:new).with(trading_item).
        and_return(stage_calculator)
      stage_calculator.should_receive(:stage_of_round_of_bids?).and_return(true)
      subject.should_receive(:all_bidders_have_bid_for_last_round?).
        and_return(true)

      expect(subject.calculate).to eq 3
    end
  end
end
