# encoding: utf-8
require 'spec_helper'

describe TradingItemBidRoundOfBidsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'at stage of round_of_bids' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.trading_items.first }
    let(:bidder1) { trading.bidders.first }
    let(:bidder2) { trading.bidders.second }
    let(:bidder3) { trading.bidders.last }

    before do
      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 100.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 101.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 0,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 102.0,
        :stage => TradingItemBidStage::PROPOSALS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)
    end

    describe 'GET new' do
      it 'assigns the parent trading item to the bid' do
        get :new, :trading_item_id => trading_item.id

        expect(assigns(:trading_item_bid).trading_item).to eq trading_item
        expect(assigns(:trading_item_bid).amount).to eq 0
        expect(assigns(:trading_item_bid).round).to eq 1
        expect(assigns(:trading_item_bid).bidder).to eq bidder1
        expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITH_PROPOSAL
        expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::ROUND_OF_BIDS
      end
    end

    describe 'POST create' do
      it 'should create a bid with fixed values' do
        post :create, :trading_id => trading.id,
           :trading_item_bid => {
             :trading_item_id => trading_item.id,
             :status => TradingItemBidStatus::WITHOUT_PROPOSAL
           }

        expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITHOUT_PROPOSAL
        expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::ROUND_OF_BIDS
        expect(assigns(:trading_item_bid).round).to eq 1
      end
    end
  end

  context 'when not at stage of round of bids' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.trading_items.first }

    describe 'GET #new' do
      it 'should return 404' do
        get :new, :trading_item_id => trading_item.id

        expect(response.code).to eq '404'
        expect(response.body).to match /A página que você procura não existe/
      end
    end

    describe 'POST #create' do
      it 'should return 404' do
        post :create, :trading_item_id => trading_item.id

        expect(response.code).to eq '404'
        expect(response.body).to match /A página que você procura não existe/
      end
    end
  end
end
