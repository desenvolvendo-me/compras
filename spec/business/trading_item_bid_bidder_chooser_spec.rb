require 'unit_helper'
require 'app/business/trading_item_bid_bidder_chooser'

describe TradingItemBidBidderChooser do
  subject do
    described_class.new(trading_item)
  end

  let(:trading_item) { double(:trading_item) }

  describe '#choose' do
    it 'should choose the next bidder available' do
      first_bidder = double(:first_bidder)
      second_bidder = double(:second_bidder)
      third_bidder = double(:third_bidder)

      trading_item.should_receive(:bidders_available_for_current_round).
                   and_return([first_bidder, second_bidder, third_bidder])

      expect(subject.choose).to eq first_bidder
    end
  end
end
