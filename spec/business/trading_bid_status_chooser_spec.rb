require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/trading_item_bid_status'
require 'active_support/core_ext/big_decimal/conversions'
require 'app/business/trading_bid_status_chooser'

describe TradingBidStatusChooser do
  let(:bid) { double(:bid) }

  subject do
    described_class.new(bid)
  end

  describe '#choose' do
    context "when bid's amount is greater than zero" do
      before do
        bid.stub(amount: 1)
      end

      it "should return 'with_proposal'" do
        expect(subject.choose).to eq TradingItemBidStatus::WITH_PROPOSAL
      end
    end

    context "when bid's amount is equal to zero" do
      before do
        bid.stub(amount: 0)
      end

      it "should return 'declined'" do
        expect(subject.choose).to eq TradingItemBidStatus::DECLINED
      end
    end
  end
end
