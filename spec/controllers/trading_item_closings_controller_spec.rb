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

    let(:bidder) { Bidder.make!(:licitante) }

    before do
      TradingItemWinner.should_receive(:winner).with(trading_item).and_return(bidder)
    end

    describe 'GET #new' do
      it 'should assigns trading_item' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)

        get :new, :trading_item_id => 10

        expect(assigns(:trading_item_closing).trading_item_id).to eq 10
      end

      it 'should assigns bidder' do
        TradingItem.should_receive(:find).with("10").and_return(trading_item)

        get :new, :trading_item_id => 10

        expect(assigns(:trading_item_closing).bidder).to eq bidder
      end
    end

    describe 'POST #create' do
      let(:trading_item_closing) { double(:trading_item_closing) }
      let(:trading_item_closing_decorator) { double(:trading_item_closing_decorator) }

      before do
        trading_item_closing.stub(:decorator => trading_item_closing_decorator)
      end

      context 'when trading not allow closing' do
        before do
          trading_item.stub(:trading_allow_closing? => false)
        end

        it 'should redirect to index of trading_items' do
          TradingItem.should_receive(:find).with("10").and_return(trading_item)
          TradingItemClosing.any_instance.should_receive(:save).and_return(true)

          post :create, :trading_item_id => 10

          expect(response).to redirect_to(trading_items_path(:trading_id => 5))
        end
      end

      context 'when trading allow closing' do
        before do
          trading_item.stub(:trading_allow_closing? => true)
        end

        it 'should redirect to new trading_closing' do
          TradingItem.should_receive(:find).with("10").and_return(trading_item)
          TradingItemClosing.any_instance.should_receive(:save).and_return(true)

          post :create, :trading_item_id => 10

          expect(response).to redirect_to(new_trading_closing_path(:trading_id => 5))
        end
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
