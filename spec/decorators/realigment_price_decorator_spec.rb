require 'decorator_helper'
require 'app/decorators/realigment_price_decorator'

describe RealigmentPriceDecorator do
  describe '#price_with_precision' do
    it 'returns the formatted price' do
      component.stub(:price).and_return 1000.12
      expect(subject.price_with_precision).to eql "1.000,12"
    end
  end
end
