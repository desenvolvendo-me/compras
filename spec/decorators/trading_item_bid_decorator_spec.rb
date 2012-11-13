require 'decorator_helper'
require 'app/decorators/trading_item_bid_decorator'

describe TradingItemBidDecorator do
  describe '#trading_item_last_proposal_value' do
    it 'should return number with precision' do
      component.stub(:trading_item_last_proposal_value).and_return(12345.67)

      expect(subject.trading_item_last_proposal_value).to eq '12.345,67'
    end
  end

  describe '#minimum_limit' do
    it 'should return number with precision' do
      component.stub(:minimum_limit).and_return(1234.56)

      expect(subject.minimum_limit).to eq '1.234,56'
    end
  end
end
