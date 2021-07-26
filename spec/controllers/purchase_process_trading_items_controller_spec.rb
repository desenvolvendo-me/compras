require 'spec_helper'

describe PurchaseProcessTradingItemsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'with an item' do
    let(:item) { double(:item) }

    describe 'GET #next_bid' do
      it 'should calculate ne next_bid' do
        PurchaseProcessTradingItem.should_receive(:find).with('10').and_return(item)

        NextBidCalculator.should_receive(:next_bid).with(item)

        item.should_receive(:bids_historic)
        item.should_receive(:lowest_bid)

        get :next_bid, id: 10, format: 'json'
      end
    end

    describe 'GET #creditor_list' do
      it 'should return the list of creditor for a given item' do
        PurchaseProcessTradingItem.should_receive(:find).with('5').and_return(item)

        item.should_receive(:creditors_ordered_outer)

        get :creditor_list, id: 5, format: 'json'
      end
    end

    describe 'POST #undo_last_bid' do
      context 'when undo last bid successfuly' do
        it 'should redirect to next_bid' do
          item.stub(to_params: '4')

          PurchaseProcessTradingItem.should_receive(:find).with('4').and_return(item)

          item.should_receive(:transaction).and_yield
          TradingBidRemover.should_receive(:undo).with(item).and_return(true)
          TradingItemStatusChanger.should_receive(:change).with(item)
          TradingBidCreator.should_receive(:create!).with(item)

          post :undo_last_bid, id: 4

          expect(response).to redirect_to(next_bid_purchase_process_trading_item_path(item))
        end
      end

      context 'when undo last bid with error' do
        it 'should render errors' do
          item.stub(to_params: '4')

          PurchaseProcessTradingItem.should_receive(:find).with('4').and_return(item)

          item.should_receive(:transaction).and_yield
          TradingBidRemover.should_receive(:undo).with(item).and_return(false)
          TradingBidCreator.should_not_receive(:create!)

          post :undo_last_bid, id: 4

          expect(response.code).to eq '422'
          expect(JSON.parse(response.body)).to eq({
            "errors" => ["não há lance para ser desfeito"]
          })
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when has no errors' do
      it 'should redirect to next_bid' do
        item = double(:item)

        PurchaseProcessTradingItem.should_receive(:find).with("10").and_return(item)

        item.should_receive(:localized).and_return(item)
        item.should_receive(:assign_attributes).with({ 'reduction_rate_value' => '10,00', 'reduction_rate_percent' => '0,00'}, as: :trading_user)
        item.should_receive(:save).and_return(true)

        put :update, id: 10, purchase_process_trading_item: { reduction_rate_value: '10,00', reduction_rate_percent: '0,00' }

        expect(response).to redirect_to(next_bid_purchase_process_trading_item_path(item))
      end
    end

    context 'when has errors' do
      it 'should return the errors' do
        item = double(:item)
        errors = double(:errors, full_messages: ["error"])

        PurchaseProcessTradingItem.should_receive(:find).with("10").and_return(item)

        item.should_receive(:localized).and_return(item)
        item.should_receive(:assign_attributes).with({ 'reduction_rate_value' => '10,00', 'reduction_rate_percent' => '10,00'}, as: :trading_user)
        item.should_receive(:save).and_return(false)
        item.should_receive(:errors).and_return(errors)

        put :update, id: 10, purchase_process_trading_item: { reduction_rate_value: '10,00', reduction_rate_percent: '10,00' }

        expect(response.code).to eq '422'
        expect(response.body).to eq '{"errors":["error"]}'
      end
    end
  end

  describe 'GET #creditor_winner_items' do
    let(:trading_item) { double(:trading_item) }

    it 'renders the creditor winner items as json' do
      PurchaseProcessTradingItem.
        should_receive(:trading_id).with(3).
        and_return(trading_item)

      trading_item.
        should_receive(:creditor_winner_items).with(2)

      get :creditor_winner_items, creditor_id: 2, trading_id: 3, format: :json

      expect(response).to render_template :creditor_winner_items
    end
  end
end
