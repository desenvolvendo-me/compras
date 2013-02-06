require 'spec_helper'

describe TradingItemsHelper do
  let(:resource) { double(:resource, :id => 1) }

  before do
    helper.stub(:resource).and_return(resource)
  end

  describe '#edit_trading_item_bid_proposal' do
    let(:bidder) { double(:bidder) }
    let(:trading_item_bid) { double(:trading_item_bid, :id => 15, :to_param => '15') }

    it 'should returns the path to edit the proposal of that bidder' do
      bidder.stub(:last_bid).and_return(trading_item_bid)

      expect(helper.edit_trading_item_bid_proposal(bidder)).to eq '/trading_item_bid_proposals/15/edit?trading_item_id=1'
    end
  end

  describe '#trading_item_closing_path' do
    context 'when closed' do
      let(:closing) { double(:closing, :to_param => "3")}

      before do
        resource.stub(:closed? => true)
        resource.stub(:closing => closing)
      end

      it 'should returns path to edit the trading_item_closing' do
        expect(helper.trading_item_closing_path).to eq '/trading_item_closings/3/edit'
      end
    end

    context 'when closed' do
      before do
        resource.stub(:closed? => false)
      end

      it 'should returns path to edit the trading_item_closing' do
        expect(helper.trading_item_closing_path).to eq '/trading_item_closings/new?trading_item_id=1'
      end
    end
  end

  describe '#negotiation_link' do
    let(:decorator) { double(:decorator) }
    let(:bidder) { double(:bidder, :id => 10) }

    before do
      resource.stub(:decorator => decorator)
    end

    context 'when bidder is the current for negotiation' do
      before do
        decorator.stub(:current_bidder_for_negotiation? => true)
      end

      it 'should return the link to new negotiation' do
        helper.should_receive(:link_to).
               with('Negociar', '/trading_item_bid_negotiations/new?bidder_id=10&trading_item_id=1', :class => "button primary").
               and_return('link')

        expect(helper.negotiation_link(bidder)).to eq 'link'
      end
    end

    context 'when bidder is not the current for negotiation' do
      before do
        decorator.stub(:current_bidder_for_negotiation? => false)
      end

      context 'when bidder is the bidder of last negotiation' do
        let(:last_negotiation) { double(:last_negotiation, :to_param => "5") }

        before do
          decorator.stub(:last_bidder_for_negotiation? => true)
          decorator.stub(:last_negotiation => last_negotiation)
        end

        it 'should return the link to redo the negotiation' do
          helper.should_receive(:link_to).
                 with('Refazer neg.', '/trading_item_bid_negotiations/5', :method => 'delete', :class => 'button').
                 and_return('link')

          expect(helper.negotiation_link(bidder)).to eq 'link'
        end
      end

      context 'when bidder is not the bidder of last negotiation' do
        before do
          decorator.stub(:last_bidder_for_negotiation? => false)
        end

        it { expect(helper.negotiation_link(bidder)).to be_nil }
      end
    end
  end
end
