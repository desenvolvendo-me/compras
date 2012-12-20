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
        expect(assigns(:trading_item_bid).round).to eq 1
        expect(assigns(:trading_item_bid).bidder).to eq bidder2
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

    context 'with two bid at round of bids' do
      describe 'delete #destroy' do
        it 'should update the last bid' do
          # I needed to use variables instead let blocks because for an
          # unknow reason let was being created at random order
          bid = TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder1.id,
            :amount => 99.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)

          last_bid = TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder2.id,
            :amount => 98.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)

          delete :destroy, :id => last_bid.id, :trading_item_id => trading_item.id

          expect(response).to redirect_to(new_trading_item_bid_round_of_bid_path(:trading_item_id => trading_item.id, :anchor => :title))
        end

        it 'should return 404 if its not the last bid' do
          # I needed to use variables instead let blocks because for an
          # unknow reason let was being created at random order
          bid = TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder1.id,
            :amount => 99.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)

          last_bid = TradingItemBid.create!(
            :round => 1,
            :trading_item_id => trading_item.id,
            :bidder_id => bidder2.id,
            :amount => 98.0,
            :stage => TradingItemBidStage::ROUND_OF_BIDS,
            :status => TradingItemBidStatus::WITH_PROPOSAL)

          delete :destroy, :id => bid.id, :trading_item_id => trading_item.id

          expect(response.code).to eq "404"
          expect(response.body).to match /A página que você procura não existe/
        end
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
