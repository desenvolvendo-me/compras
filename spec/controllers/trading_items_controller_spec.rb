# encoding: utf-8
require 'spec_helper'

describe TradingItemsController do
  describe 'PUT #update' do
    before do
      controller.stub(:authenticate_user!)
      controller.stub(:authorize_resource!)
    end

    it 'should redirect to trading item list when edited' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.items.first

      put :update, :id => item.id,
                   :trading_item => item.attributes.except('proposals_activated_at')

      expect(response).to redirect_to(trading_items_path(:trading_id => trading.id))
    end
  end

  describe 'GET #activate_proposals' do
    let(:trading_item) do
      double(:trading_item, :to_param => '4')
    end

    before do
      controller.stub(:authenticate_user!)
      controller.stub(:authorize_resource!)
    end

    it 'should activate_proposals' do
      controller.stub(:resource => trading_item)

      trading_item.should_receive(:transaction).and_yield
      trading_item.should_receive(:activate_proposals!).and_return(true)

      get :activate_proposals, :id => 4

      expect(response).to redirect_to(classification_trading_item_path(trading_item))
    end
  end

  describe 'GET #classification' do
    context 'with no proposals activated' do
      it 'should check permission for read' do
        trading = Trading.make!(:pregao_presencial)
        item = trading.items.first

        controller.stub(:authenticate_user!)
        controller.should_receive(:authorize!).with(:read, 'tradings')

        get :classification, :id => item.id

        expect(response.code).to eq '401'
        expect(response.body).to match(/Você não tem acesso a essa página/)
      end
    end

    context 'at classification' do
      let(:bidder1) { Bidder.make!(:licitante) }
      let(:bidder2) { Bidder.make!(:licitante_sobrinho) }
      let(:bidder3) { Bidder.make!(:licitante_com_proposta_4) }

      let :licitation_process do
        LicitationProcess.make!(:pregao_presencial,
          :bidders => [bidder1, bidder2, bidder3])
      end

      let :trading do
        Trading.make!(:pregao_presencial, :licitation_process => licitation_process)
      end

      let(:trading_item) { trading.items.first }

      before do
        controller.stub(:authenticate_user!)
        controller.stub(:authorize_resource!)

        TradingConfiguration.make!(:pregao)

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
          :amount => 85.0,
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
      end

      context 'with proposals activated' do
        before do
          trading_item.update_column(:proposals_activated_at, Date.current)
        end

        it 'should render classification_for_activated_proposals' do
          get :classification, :id => trading_item.id

          expect(response).to render_template 'classification_for_activated_proposals'
        end
      end

      context 'with proposals not activated' do
        it 'should render classification_for_activated_proposals' do
          get :classification, :id => trading_item.id

          expect(response).to render_template 'classification'
        end
      end

    end
  end

  describe 'GET #proposal_report' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'tradings')

      get :proposal_report, :id => item.id
    end

    it 'should raise unauthorized when not at stage of proposal_report' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.items.first

      controller.stub(:authenticate_user!)
      controller.stub(:authorize_resource!)

      get :proposal_report, :id => item.id

      expect(response.code).to eq '401'
      expect(response.body).to match(/Você não tem acesso a essa página/)
    end

    context 'on proposal_report' do
      let(:trading) { Trading.make!(:pregao_presencial) }
      let(:item) { trading.items.first }
      let(:bidder1) { trading.bidders.first }
      let(:bidder2) { trading.bidders.second }
      let(:bidder3) { trading.bidders.last }

      before do
        controller.stub(:authenticate_user!)
        controller.stub(:authorize_resource!)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => item.id,
          :bidder_id => bidder1.id,
          :amount => 100.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => item.id,
          :bidder_id => bidder2.id,
          :amount => 101.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)

        TradingItemBid.create!(
          :round => 0,
          :trading_item_id => item.id,
          :bidder_id => bidder3.id,
          :amount => 102.0,
          :stage => TradingItemBidStage::PROPOSALS,
          :status => TradingItemBidStatus::WITH_PROPOSAL)
      end

      it 'should raise unauthorized when not at stage of proposal_report' do
        get :proposal_report, :id => item.id

        expect(response.code).to eq '200'
        expect(response).to render_template 'proposal_report'
      end
    end
  end

  describe 'GET #offers' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'tradings')

      get :offers, :id => item.id
    end
  end
end
