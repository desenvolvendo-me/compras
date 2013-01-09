require 'spec_helper'

describe BidderDisqualificationsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  context 'with bidder_id and trading_item_id at params' do
    let(:trading_item) { double(:trading_item, :id => 4) }
    let(:bidder) { double(:bidder, :id => 43) }

    context 'with valid bidder' do
      before do
        subject.stub(:bidder_valid? => true)
      end

      describe 'GET #new' do
        it 'should assign bidder_id' do
          TradingItem.should_receive(:find).with("4").and_return(trading_item)
          Bidder.should_receive(:find).with("43").and_return(bidder)

          get :new, :bidder_id => 43, :trading_item_id => 4

          expect(assigns(:bidder_disqualification).bidder_id).to eq bidder.id
        end

        it 'should assign created_at' do
          TradingItem.should_receive(:find).with("4").and_return(trading_item)
          Bidder.should_receive(:find).with("43").and_return(bidder)

          get :new, :bidder_id => 43, :trading_item_id => 4

          expect(assigns(:bidder_disqualification).created_at.to_date).to eq Date.current
        end
      end

      describe 'POST #create' do
        it 'should redirect to classification' do
          TradingItem.should_receive(:find).with("4").and_return(trading_item)
          BidderDisqualification.any_instance.should_receive(:save).and_return(true)

          post :create, :trading_item_id => 4

          expect(response).to redirect_to(classification_trading_item_path(trading_item))
        end
      end

      context 'with an existing disqualification' do
        let(:real_bidder) { Bidder.make!(:licitante) }

        let(:disqualification) do
          BidderDisqualification.create!(:bidder_id => real_bidder.id, :reason => "motivo")
        end

        describe 'PUT #update' do
          it 'should redirect to classification' do
            TradingItem.should_receive(:find).with("4").and_return(trading_item)

            put :update, :id => disqualification.id, :trading_item_id => 4

            expect(response).to redirect_to(classification_trading_item_path(trading_item))
          end
        end

        describe 'DELETE #destroy' do
          it 'should redirect to classification' do
            TradingItem.should_receive(:find).with("4").and_return(trading_item)

            delete :destroy, :id => disqualification.id, :trading_item_id => 4

            expect(response).to redirect_to(classification_trading_item_path(trading_item))
          end
        end
      end
    end

    context 'with invalid bidder' do
      before do
        subject.stub(:bidder_valid? => false)
      end

      describe 'GET #new' do
        it 'should raise 404' do
          TradingItem.should_receive(:find).with("4").and_return(trading_item)

          expect {
            get :new, :bidder_id => 43, :trading_item_id => 4
          }.to raise_exception ActiveRecord::RecordNotFound
        end
      end

      describe 'POST #create' do
        it 'should raise 404' do
          TradingItem.should_receive(:find).with("4").and_return(trading_item)

          expect {
            post :create, :bidder_id => 43, :trading_item_id => 4
          }.to raise_exception ActiveRecord::RecordNotFound
        end
      end
    end
  end

  context 'without trading_item_id at params' do
    describe 'GET #new' do
      it 'should raise 404' do
        expect {
          get :new
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    describe 'POST #create' do
      it 'should raise 404' do
        expect {
          post :create
        }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'with an existing disqualification' do
      let(:real_bidder) { Bidder.make!(:licitante) }

      let(:disqualification) do
        BidderDisqualification.create!(:bidder_id => real_bidder.id, :reason => "motivo")
      end

      describe 'PUT #update' do
        it 'should redirect to classification' do
          expect {
            put :update, :id => disqualification.id, :trading_item_id => 4
          }.to raise_exception ActiveRecord::RecordNotFound
        end
      end

      describe 'DELETE #destroy' do
        it 'should redirect to classification' do
          expect {
            delete :destroy, :id => disqualification.id, :trading_item_id => 4
          }.to raise_exception ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
