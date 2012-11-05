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

      get :new, :trading_item_id => trading_item.id

      expect(assigns(:trading_item_bid).trading_item).to eq trading_item
    end
  end

  describe 'POST #create' do
    it 'assigns with_proposal as default status' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      post :create, :trading_id => trading.id, :trading_item_id => trading_item.id

      expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITH_PROPOSAL
    end
  end
end
