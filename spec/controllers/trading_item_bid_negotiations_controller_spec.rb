#encoding: utf-8
require 'spec_helper'

describe TradingItemBidNegotiationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'at stage of negotiation' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }
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

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 90.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :amount => 88.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 1,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :amount => 87.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder1.id,
        :amount => 86.0,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITH_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder2.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      TradingItemBid.create!(
        :round => 2,
        :trading_item_id => trading_item.id,
        :bidder_id => bidder3.id,
        :stage => TradingItemBidStage::ROUND_OF_BIDS,
        :status => TradingItemBidStatus::WITHOUT_PROPOSAL)

      # This is a workaround, because the before create callback is not
      # storing the right value using machinist.
      trading.percentage_limit_to_participate_in_bids = 10.0
      trading.save!
    end

    describe 'GET new' do
      it 'assigns the parent trading item to the bid' do
        get :new, :trading_item_id => trading_item.id

        expect(assigns(:trading_item_bid).trading_item).to eq trading_item
        expect(assigns(:trading_item_bid).amount).to eq 0
        expect(assigns(:trading_item_bid).bidder).to eq bidder1
        expect(assigns(:trading_item_bid).status).to eq TradingItemBidStatus::WITH_PROPOSAL
        expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::NEGOTIATION
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
        expect(assigns(:trading_item_bid).stage).to eq TradingItemBidStage::NEGOTIATION
        expect(assigns(:trading_item_bid).bidder).to eq bidder1
        expect(assigns(:trading_item_bid).round).to eq 0
      end
    end

    describe 'DELETE #destroy' do
      let(:negotiation) do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => bidder1.id,
          :amount => 84.0,
          :stage => TradingItemBidStage::NEGOTIATION,
          :status => TradingItemBidStatus::WITH_PROPOSAL)
      end

      it 'should destroy' do
        delete :destroy, :id => negotiation.id, :trading_item_id => trading_item.id

        expect(response).to redirect_to(classification_trading_item_path(trading_item))
      end
    end
  end

  context 'at another stage' do
    let(:trading) { Trading.make!(:pregao_presencial) }
    let(:trading_item) { trading.items.first }

    describe 'GET #new' do
      it 'should return 404' do
        expect {
          get :new, :trading_item_id => trading_item.id
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'POST #create' do
      it 'should return 404' do
        expect {
          post :create, :trading_item_id => trading_item.id
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'DELETE #destroy' do
      let(:bid) do
        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => trading_item.id,
          :bidder_id => trading.bidders.first.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)
      end

      it 'should return 404' do
        expect { delete :destroy, :id => bid.id, :trading_item_id => trading_item.id }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
