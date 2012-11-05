require 'spec_helper'

describe TradingItemsController do
  before do
    sign_in User.make!(:sobrinho_as_admin_and_employee)
  end

  describe 'PUT #update' do
    it 'should redirect to trading item list when editted' do
      trading = Trading.make!(:pregao_presencial)
      item = trading.trading_items.first

      subject.should_receive(:get_parent).and_return(trading)

      put :update, :id => item.id, :trading_item => item.attributes

      expect(response).to redirect_to(trading_items_path(:trading_id => trading.id))
    end
  end
end
