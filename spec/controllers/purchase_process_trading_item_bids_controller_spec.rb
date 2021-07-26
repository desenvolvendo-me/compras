require 'spec_helper'

describe PurchaseProcessTradingItemBidsController do
  before do
    controller.stub(:authenticate_user!)
    controller.stub(:authorize_resource!)
  end

  describe 'PUT #update' do
    context 'when has no errors' do
      it 'should update amount, calculate status and number and create and clean bids' do
        trading = double(:trading)
        item = double(:item)
        bid = double(:bid, trading: trading, item: item)
        status_chooser = double(:status_chooser)

        PurchaseProcessTradingItemBid.should_receive(:find).with("10").and_return(bid)
        TradingBidStatusChooser.should_receive(:new).with(bid).and_return(status_chooser)
        status_chooser.should_receive(:choose).and_return('status')
        TradingBidNumberCalculator.
          should_receive(:calculate).
          with(item).
          and_return(5)

        bid.should_receive(:transaction).and_yield
        bid.should_receive(:localized).and_return(bid)
        bid.should_receive(:assign_attributes).with({ 'amount' => '15'}, as: :trading_user)
        bid.should_receive(:status=).with('status')
        bid.should_receive(:number=).with(5)
        bid.should_receive(:save).and_return(true)

        TradingBidCreator.should_receive(:create!).with(item)
        TradingBidCleaner.should_receive(:clean).with(item)
        TradingItemStatusChanger.should_receive(:change).with(item)

        put :update, id: 10, purchase_process_trading_item_bid: { amount: 15 }

        expect(response.code).to eq '200'
        expect(response.body).to eq '{}'
      end
    end

    context 'when has errors' do
      it 'should return the errors' do
        trading = double(:trading)
        item = double(:item)
        bid = double(:bid, trading: trading, item: item)
        status_chooser = double(:status_chooser)
        errors = double(:errors, full_messages: ["error"])

        PurchaseProcessTradingItemBid.should_receive(:find).with("10").and_return(bid)
        TradingBidStatusChooser.should_receive(:new).with(bid).and_return(status_chooser)
        status_chooser.should_receive(:choose).and_return('status')
        TradingBidNumberCalculator.
          should_receive(:calculate).
          with(item).
          and_return(5)

        bid.should_receive(:transaction).and_yield
        bid.should_receive(:localized).and_return(bid)
        bid.should_receive(:assign_attributes).with({ 'amount' => '15'}, as: :trading_user)
        bid.should_receive(:status=).with('status')
        bid.should_receive(:number=).with(5)
        bid.should_receive(:save).and_return(false)
        bid.should_receive(:errors).and_return(errors)

        TradingBidCreator.should_not_receive(:create_items_bids!)
        TradingBidCleaner.should_not_receive(:clean)

        put :update, id: 10, purchase_process_trading_item_bid: { amount: 15 }

        expect(response.code).to eq '422'
        expect(response.body).to eq '{"errors":["error"]}'
      end
    end
  end
end
