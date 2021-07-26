require 'unit_helper'
require 'app/business/trading_bid_number_calculator'

describe TradingBidNumberCalculator do
  let(:item) { double(:item) }

  describe '#calculate_number' do
    subject do
      described_class.new(item)
    end

    context 'when has no bids' do
      before do
        subject.stub(bid_numbers_by_item: [])
      end

      it 'should return 1' do
        expect(subject.calculate_number).to eq 1
      end
    end

    context 'when has bids' do
      before do
        subject.stub(bid_numbers_by_item: [3, 2, 1])
      end

      it 'should return last bid number plus one' do
        expect(subject.calculate_number).to eq 4
      end
    end
  end

  describe '.calculate' do
    it 'should instantiate and call calculate_number' do
      instance = double(:instance)

      described_class.should_receive(:new).with(item).and_return(instance)
      instance.should_receive(:calculate_number)

      described_class.calculate(item)
    end
  end
end
