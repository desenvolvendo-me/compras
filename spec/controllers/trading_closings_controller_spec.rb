require 'spec_helper'

describe TradingClosingsController do
  before do
    controller.stub(:authenticate_user!)
  end

  describe 'GET #new' do
    it 'should assign trading as default value' do
      trading = Trading.make!(:pregao_presencial)

      controller.stub(:authorize_resource!)

      get :new, :trading_id => trading.id

      expect(assigns(:trading_closing).trading).to eq(trading)
    end

    it 'should check permission for new' do
      controller.should_receive(:authorize!).with("new", 'tradings')

      get :new
    end
  end
end
