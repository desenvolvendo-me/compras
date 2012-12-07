require 'unit_helper'
require 'app/business/trading_item_generator'

describe TradingItemGenerator do
  let(:trading) { double(:trading, :id => 1) }
  let(:trading_item_repository) { double(:trading_item_repository) }

  describe '.generate!' do
    context 'with items' do
      let(:item1) { double(:item1, :id => 5) }
      let(:item2) { double(:item2, :id => 30) }

      before do
        trading.stub(:licitation_process_items).and_return([item1, item2])
      end

      it 'should create trading_items based on items of licitation_process' do
        trading_item_repository.should_receive(:create!).
          with(:trading_id => 1, :administrative_process_budget_allocation_item_id => 5)

        trading_item_repository.should_receive(:create!).
          with(:trading_id => 1, :administrative_process_budget_allocation_item_id => 30)

        described_class.generate!(trading, trading_item_repository)
      end
    end

    context 'without items' do
      before do
        trading.stub(:licitation_process_items).and_return([])
      end

      it 'should do nothing' do
        trading_item_repository.should_not_receive(:create!)

        described_class.generate!(trading, trading_item_repository)
      end
    end
  end
end
