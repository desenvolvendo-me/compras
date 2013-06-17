require 'spec_helper'

describe PurchaseProcessTradingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET #new' do
    let(:purchase_process) { double(:purchase_process, to_param: '10') }
    let(:trading) { double(:trading, to_param: "3") }

    context 'when there is no trading' do
      it 'should create trading' do
        LicitationProcess.should_receive(:find).with('10').and_return(purchase_process)
        TradingCreator.should_receive(:create!).with(purchase_process).and_return(trading)

        get :new, purchase_process_id: 10

        expect(response).to redirect_to(bids_purchase_process_trading_path(trading))
      end
    end

    context 'when there is a trading' do
      it 'should not create a new trading and redirect to purchase process' do
        LicitationProcess.should_receive(:find).with('10').and_return(purchase_process)
        TradingCreator.should_receive(:create!).with(purchase_process).and_return(nil)

        get :new, purchase_process_id: 10

        expect(response).to redirect_to(edit_licitation_process_path(purchase_process))
      end
    end
  end

  describe 'GET #bids' do
    it 'should create bids, and return item and the next_bid' do
      item                = double(:item)
      trading             = double(:trading, items: [item])

      PurchaseProcessTrading.should_receive(:find).with("10").and_return(trading)
      trading.should_receive(:transaction).and_yield
      TradingBidCreator.should_receive(:create_items_bids!).with(trading)
      NextBidCalculator.should_receive(:next_bid).with(item)

      item.should_receive(:bids_historic)
      item.should_receive(:creditors_ordered_outer)

      get :bids, id: 10
    end
  end
end
