#encoding: utf-8
require 'spec_helper'

describe TradingItemBidsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'GET new' do
    it 'assigns the parent trading item to the bid' do
      trading_item = TradingItem.make!(:item_pregao_presencial)

      TradingItemBidBidderChooser.any_instance.should_receive(:choose)

      get :new, :trading_item_id => trading_item.id

      expect(assigns(:trading_item_bid).trading_item).to eq trading_item
      expect(assigns(:trading_item_bid).round).to eq 1
      expect(assigns(:trading_item_bid).amount).to eq 0
      expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITH_PROPOSAL
    end
  end

  describe 'POST #create' do
    it 'create and bid without proposal' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITHOUT_PROPOSAL
      expect(assigns(:trading_item_bid).round).to eq 1
    end

    it 'should redirect to new trading item bid after create' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response).to redirect_to(new_trading_item_bid_path(:trading_item_id => trading_item.id))
    end
  end
end
