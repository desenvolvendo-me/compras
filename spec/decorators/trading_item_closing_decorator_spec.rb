require 'decorator_helper'
require 'app/decorators/trading_item_closing_decorator'

describe TradingItemClosingDecorator do
  describe '#after_create_path' do
    let(:trading_item) { double(:trading_item, :trading_id => 3) }

    before do
      component.stub(:trading_item => trading_item)
    end

    context 'when trading item can be closed' do
      before do
        trading_item.stub(:trading_allow_closing? => true)
      end

      it 'should retuns the path to a new trading_closing' do
        routes.should_receive(:new_trading_closing_path).
               with(:trading_id => 3).
               and_return('new_trading_closing')

        expect(subject.after_create_path).to eq 'new_trading_closing'
      end
    end

    context 'when trading item cannot be closed' do
      before do
        trading_item.stub(:trading_allow_closing? => false)
      end

      it 'should retuns the trading items' do
        routes.should_receive(:trading_items_path).
               with(:trading_id => 3).
               and_return('trading_items')

        expect(subject.after_create_path).to eq 'trading_items'
      end
    end
  end
end
