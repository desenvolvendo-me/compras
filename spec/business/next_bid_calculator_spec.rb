require 'unit_helper'
require 'app/business/next_bid_calculator'

describe NextBidCalculator do
  let(:item) { double(:item) }

  subject do
    described_class.new(item)
  end

  describe '#next_bid' do
    context 'when next_bid is the bidder whith lowest proposal' do
      before do
        subject.stub(next_creditor_has_lowest_bid?: true)
      end

      it 'should return nil' do
        expect(subject.next_bid).to be_nil
      end
    end

    context 'when next_bid is not the bidder whith lowest proposal' do
      before do
        subject.stub(next_creditor_has_lowest_bid?: false)
      end

      it 'should return next_bid' do
        bids = double(:bids)
        next_bid = double(:next_bid)

        item.should_receive(:trading_bids).and_return(bids)
        bids.should_receive(:without_proposal).and_return(bids)
        bids.should_receive(:reorder).with(:id).and_return(bids)
        bids.should_receive(:first).and_return(next_bid)

        expect(subject.next_bid).to eq next_bid
      end
    end
  end
end
