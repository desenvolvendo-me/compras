require 'unit_helper'
require 'app/business/trading_bid_cleaner'

describe TradingBidCleaner do
  let(:item) { double(:item) }
  let(:next_bid_calculator) { double(:next_bid_calculator) }

  subject do
    described_class.new(item, next_bid_calculator: next_bid_calculator)
  end

  describe '#clean_bids' do
    let(:bids_without_proposal) { double(:bids_without_proposal) }

    before do
      subject.stub(bids_without_proposal: bids_without_proposal)
    end

    context 'when next_bis is nil' do
      before do
        subject.stub(:next_bid => nil)
      end

      it 'should clean bids without proposal' do
        bids_without_proposal.should_receive(:destroy_all)

        subject.clean_bids
      end
    end

    context 'when next_bis is not' do
      before do
        subject.stub(:next_bid => 'bid')
      end

      it 'should do nothing' do
        bids_without_proposal.should_not_receive(:destroy_all)

        subject.clean_bids
      end
    end
  end

  describe '.clean' do
    it 'should instantiate and call clean_bids' do
      instance = double(:instance)

      described_class.should_receive(:new).with(item).and_return(instance)
      instance.should_receive(:clean_bids)

      described_class.clean(item)
    end
  end
end
