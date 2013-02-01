require 'unit_helper'
require 'active_support/core_ext/big_decimal/conversions'
require 'active_support/core_ext/module/delegation'
require 'app/business/trading_item_bidder_selector'

describe TradingItemBidderSelector do
  let(:bidders) { double(:bidders) }
  let(:bids) { double(:bids) }
  let(:trading_item) do
    double(:trading_item,
      :id => 12,
      :bidders => bidders,
      :bids => bids,
      :percentage_limit_to_participate_in_bids => 10.0)
  end

  describe 'using a new instance' do
    subject do
      described_class.new(trading_item)
    end

    describe 'delegates' do
      it 'should delegate bidders to trading_item' do
        trading_item.should_receive(:bidders)

        subject.bidders
      end

      it 'should delegate bids to trading_item' do
        trading_item.should_receive(:bids)

        subject.bids
      end

      it 'should delegate percentage_limit_to_participate_in_bids to trading_item' do
        trading_item.should_receive(:percentage_limit_to_participate_in_bids)

        subject.percentage_limit_to_participate_in_bids
      end
    end

    describe '#bidders_selected' do
      context 'when have less than 3 bidders selected by limit_value' do
        let(:with_proposal) { double(:with_proposal) }
        let(:at_stage_of_proposals) { double(:at_stage_of_proposals) }
        let(:bid1) { double(:bid1, :amount => 100) }
        let(:bid2) { double(:bid2, :amount => 101) }
        let(:bid3) { double(:bid3, :amount => 102) }
        let(:bid4) { double(:bid4, :amount => 103) }


        before do
          subject.stub(:bidders_selected_by_limit_value => ['bidder1'])
        end

        it 'should get bidders with lowest values' do
          bids.should_receive(:with_proposal).and_return(with_proposal)
          with_proposal.should_receive(:at_stage_of_proposals).and_return(at_stage_of_proposals)
          at_stage_of_proposals.should_receive(:reorder).and_return([bid1, bid2, bid3, bid4])
          bidders.should_receive(:under_limit_value).with(12, 102).and_return(['bidder1', 'bidder2', 'bidder3', 'bidder4'])

          expect(subject.bidders_selected).to eq ['bidder1', 'bidder2', 'bidder3', 'bidder4']
        end
      end

      context 'when have more than 2 bidders selected by limit_value' do
        let(:with_proposal) { double(:with_proposal) }
        let(:at_stage_of_proposals) { double(:at_stage_of_proposals) }

        it 'should get bidders with lowest values' do
          bids.should_receive(:with_proposal).
               at_least(1).times.and_return(with_proposal)

          with_proposal.should_receive(:at_stage_of_proposals).
                        at_least(1).times.and_return(at_stage_of_proposals)
          at_stage_of_proposals.should_receive(:minimum).
                                at_least(1).times.with(:amount).and_return(100)
          bidders.should_receive(:under_limit_value).
                  at_least(1).times.with(12, 110.0).and_return(['bidder1', 'bidder2', 'bidder3'])

          expect(subject.bidders_selected).to eq ['bidder1', 'bidder2', 'bidder3']
        end
      end
    end
  end

  context 'class methods' do
    let(:instance) { double(:instance) }

    describe '.selected' do
      it 'should instantiate and call bidders_selected' do
        described_class.should_receive(:new).with(trading_item).and_return(instance)
        instance.should_receive(:bidders_selected)

        described_class.selected(trading_item)
      end
    end

    describe '.not_selected' do
      it 'should instantiate and call bidders_not_selected' do
        described_class.should_receive(:new).with(trading_item).and_return(instance)
        instance.should_receive(:bidders_not_selected)

        described_class.not_selected(trading_item)
      end
    end
  end
end
