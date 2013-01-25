require 'decorator_helper'
require 'app/decorators/trading_closing_decorator'

describe TradingClosingDecorator do
  describe '#created_at_date' do
    it 'should returns the localized date of creation' do
      component.stub(:created_at => DateTime.new(2013, 1, 25, 15, 53, 12))

      expect(subject.created_at_date).to eq '25/01/2013'
    end
  end
end
