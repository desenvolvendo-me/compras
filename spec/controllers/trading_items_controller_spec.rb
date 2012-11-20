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

      subject.should_receive(:parent).and_return(trading)

      put :update, :id => item.id, :trading_item => item.attributes

      expect(response).to redirect_to(trading_items_path(:trading_id => trading.id))
    end
  end

  describe 'GET #classification' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'trading_items')

      get :classification, :id => item.id
    end
  end

  describe 'GET #proposal_report' do
    it 'should check permission for read' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      controller.stub(:authenticate_user!)
      controller.should_receive(:authorize!).with(:read, 'trading_items')

      get :proposal_report, :id => item.id
    end
  end
end
