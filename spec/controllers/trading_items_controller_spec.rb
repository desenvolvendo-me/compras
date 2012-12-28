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
                   :trading_item => item.attributes.except('closing_date')

      expect(response).to redirect_to(trading_items_path(:trading_id => trading.id))
    end
  end

  describe 'GET #classification' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'tradings')

      get :classification, :id => item.id
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
