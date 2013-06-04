require 'decorator_helper'
require 'app/decorators/purchase_process_trading_item_bid_decorator'

describe PurchaseProcessTradingItemBidDecorator do
  describe '#percent' do
    context 'when percent is nil' do
      before do
        component.stub(percent: nil)
      end

      it 'should return -' do
        expect(subject.percent).to eq '-'
      end
    end

    context 'when percent is not null' do
      before do
        component.stub(percent: 20)
      end

      it 'should return the number whith precision' do
        expect(subject.percent).to eq '20,00'
      end
    end
  end

  describe '#amount_with_reduction' do
    context 'when amount_with_reduction' do
      before do
        component.stub(amount_with_reduction: 10.12)
      end

      it 'should return number with precision' do
        expect(subject.amount_with_reduction).to eq '10,12'
      end
    end

    context 'when has not amount_with_reduction' do
      before do
        component.stub(amount_with_reduction: nil)
      end

      it 'should return 0,00' do
        expect(subject.amount_with_reduction).to eq '0,00'
      end
    end
  end
end
