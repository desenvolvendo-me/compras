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
      expect(assigns(:trading_item_bid).round).to eq 1
      expect(assigns(:trading_item_bid).amount).to eq 0
      expect(assigns(:trading_item_bid).bidder).to eq trading_item.bidders.first
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
      expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::PROPOSALS
      expect(assigns(:trading_item_bid).round).to eq 1
    end

    it 'should redirect to new trading item bid after create when have not finished_bid_stage' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response).to redirect_to(new_trading_item_bid_path(:trading_item_id => trading_item.id))
    end

    it 'should redirect to the item bid classification when have finished_bid_stage' do
      trading = Trading.make!(:pregao_presencial)
      trading_item = trading.trading_items.first

      bidder1 = trading.bidders.first
      bidder2 = trading.bidders.second
      bidder3 = trading.bidders.last

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 120.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :disqualification_reason => 'Desclassificado',
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::DISQUALIFIED)

      post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

      expect(response).to redirect_to(classification_trading_item_path(trading_item))
    end
  end
end
