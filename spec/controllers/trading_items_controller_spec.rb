require 'spec_helper'

describe TradingItemsController do
  describe 'PUT #update' do
    before do
      controller.stub(:authenticate_user!)
      controller.stub(:authorize_resource!)
    end

    it 'should redirect to trading item list when edited' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

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
        item = trading.trading_items.first

        controller.stub(:authenticate_user!)
        controller.should_receive(:authorize!).with(:read, 'tradings')

        get :classification, :id => item.id

        expect(response).to render_template 'classification'
      end
    end

    context 'with proposals activated' do
      let(:trading_item) { double(:trading_item, :proposals_activated? => true) }

      before do
        controller.stub(:authenticate_user!)
        controller.stub(:authorize_resource!)
      end

      it 'should render classification_for_activated_proposals' do
        controller.stub(:resource => trading_item)

        get :classification, :id => 4

        expect(response).to render_template 'classification_for_activated_proposals'
      end
    end
  end

  describe 'GET #proposal_report' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'tradings')

      get :proposal_report, :id => item.id
    end
  end

  describe 'GET #offers' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'tradings')

      get :offers, :id => item.id
    end
  end
end
