require 'decorator_helper'
require 'app/decorators/trading_item_decorator'

describe TradingItemDecorator do
  describe '#unit_price' do
    context 'when unit price is nil' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price).to be_nil
      end
    end

    context 'when unit price is not nil' do
      before do
        component.stub(:unit_price).and_return(9.99)
      end

      it 'should apply precision' do
        expect(subject.unit_price).to eq '9,99'
      end
    end
  end

  describe '#quantity' do
    context 'when quantity is nil' do
      before do
        component.stub(:quantity).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.quantity).to be_nil
      end
    end

    context 'when quantity has value' do
      before do
        component.stub(:quantity).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.quantity).to eq '220,00'
      end
    end
  end

  describe "#readonly_reduction_percent" do
    it "returns 'readonly' if reduction value is present" do
      component.stub(:minimum_reduction_value? => true)
      expect(subject.readonly_reduction_percent).to eq({ :readonly => 'readonly' })
    end

    it "returns empty string if reduction value is not present" do
      component.stub(:minimum_reduction_value? => false)
      expect(subject.readonly_reduction_percent).to eq({})
    end
  end

  describe "#readonly_reduction_value" do
    it "returns 'readonly' if reduction percent is present" do
      component.stub(:minimum_reduction_percent? => true)
      expect(subject.readonly_reduction_value).to eq({ :readonly => 'readonly' })
    end

    it "returns empty string if reduction percent is not present" do
      component.stub(:minimum_reduction_percent? => false)
      expect(subject.readonly_reduction_value).to eq({})
    end
  end
end
