# encoding: utf-8
require 'spec_helper'

describe PurchaseProcessItemTradingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'with an item' do
    let(:item) { double(:item) }

    describe 'GET #next_bid' do
      it 'should calculate ne next_bid' do
        next_bid_calculator = double(:next_bid_calculator)

        PurchaseProcessItem.should_receive(:find).with('10').and_return(item)

        NextBidCalculator.should_receive(:new).with(item).and_return(next_bid_calculator)
        next_bid_calculator.should_receive(:next_bid)


        item.should_receive(:bids_historic)
        item.should_receive(:lowest_trading_bid)

        get :next_bid, id: 10, format: 'json'
      end
    end

    describe 'GET #creditor_list' do
      it 'should return the list of creditor for a given item' do
        PurchaseProcessItem.should_receive(:find).with('5').and_return(item)

        item.should_receive(:trading_creditors_ordered)

        get :creditor_list, id: 5, format: 'json'
      end
    end

    describe 'POST #undo_last_bid' do
      context 'when undo last bid successfuly' do
        it 'should redirect to next_bid' do
          item.stub(to_params: '4')

          PurchaseProcessItem.should_receive(:find).with('4').and_return(item)
          TradingBidRemover.should_receive(:undo).with(item).and_return(true)

          post :undo_last_bid, id: 4

          expect(response).to redirect_to(next_bid_purchase_process_item_trading_path(item))
        end
      end

      context 'when undo last bid with error' do
        it 'should render errors' do
          item.stub(to_params: '4')

          PurchaseProcessItem.should_receive(:find).with('4').and_return(item)
          TradingBidRemover.should_receive(:undo).with(item).and_return(false)

          post :undo_last_bid, id: 4

          expect(response.code).to eq '422'
          expect(JSON.parse(response.body)).to eq({
            "errors" => ["não há lance para ser desfeito"]
          })
        end
      end
    end
  end
end
