require 'spec_helper'

describe TradingItemClosingsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'when trading is not closed' do
    let(:trading_item) do
      double(:trading_item, :id => 10, :trading_id => 5, :closed? => false)
    end

    describe 'GET #new' do
      it 'should assigns trading_item' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)

        get :new, :trading_item_id => 10

        expect(assigns(:trading_item_closing).trading_item_id).to eq 10
      end
    end

    describe 'POST #create' do
      it 'should redirect to index of trading_items' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)
        TradingItemClosing.any_instance.should_receive(:save).and_return(true)

        post :create, :trading_item_id => 10

        expect(response).to redirect_to(trading_items_path(:trading_id => 5))
      end
    end
  end

  context 'when trading is not closed' do
    let(:trading) { double(:trading, :id => 5) }
    let(:trading_item) do
      double(:trading_item, :id => 10, :trading => trading, :closed? => true)
    end

    describe 'GET #new' do
      it 'should returns 404' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)

        expect {
          get :new, :trading_item_id => 10
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'POST #create' do
      it 'should returns 404' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)

        expect {
          post :create, :trading_item_id => 10
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end
end
