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

  describe '#trading_item_bid_or_classification_path' do
    it 'should return classification link when trading_item finished_bid_stage' do
      component.stub(:finished_bid_stage?).and_return(true)
      component.stub(:id).and_return(1)

      routes.should_receive(:classification_trading_item_path).
             with(component).and_return('classification_path')


      expect(subject.trading_item_bid_or_classification_path).to eq 'classification_path'
    end

    it 'should return new_trading_item_bid_path link when trading_item not finished_bid_stage' do
      component.stub(:finished_bid_stage?).and_return(false)
      component.stub(:id).and_return(1)

      routes.should_receive(:new_trading_item_bid_path).
             with(:trading_item_id => 1).and_return('new_trading_item_bid_path')


      expect(subject.trading_item_bid_or_classification_path).to eq 'new_trading_item_bid_path'
    end
  end
end
