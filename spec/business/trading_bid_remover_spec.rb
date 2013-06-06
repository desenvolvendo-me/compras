require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/trading_item_bid_status'
require 'app/business/trading_bid_remover'

describe TradingBidRemover do
  let(:item) { double(:item) }
  let(:last_bid) { double(:last_bid) }

  subject do
    described_class.new(item)
  end

  describe '#undo_last_bid' do
    context 'when has a last bid' do
      before do
        item.stub(last_bid: last_bid)
      end

      context 'when bid is benefited' do
        before do
          last_bid.stub(benefited?: true)
        end

        it 'should destroy the last_bid' do
          last_bid.should_receive(:destroy)

          expect(subject.undo_last_bid)
        end
      end

      context 'when bid is not benefited' do
        before do
          last_bid.stub(benefited?: false)
        end

        it 'should change status and amount' do
          last_bid.
            should_receive(:update_attributes).
            with(amount: 0, status: TradingItemBidStatus::WITHOUT_PROPOSAL).
            and_return(true)

          expect(subject.undo_last_bid)
        end
      end
    end

    context 'when has no last bid' do
      before do
        item.stub(last_bid: nil)
      end

      it 'should change status and amount' do
        expect(subject.undo_last_bid).to be_nil
      end
    end
  end

  describe '.undo' do
    it 'should instantiate and call #undo_last_bid' do
      instance = double(:instance)

      described_class.should_receive(:new).with(item).and_return(instance)
      instance.should_receive(:undo_last_bid)

      described_class.undo(item)
    end
  end
end
