require 'decorator_helper'
require 'app/decorators/purchase_process_trading_bid_decorator'

describe PurchaseProcessTradingBidDecorator do
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
end
