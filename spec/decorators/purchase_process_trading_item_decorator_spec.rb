require 'decorator_helper'
require 'app/decorators/purchase_process_trading_item_decorator'

describe PurchaseProcessTradingItemDecorator do
  context 'when lowest_bid is not present' do
    before do
      component.stub(lowest_bid: nil)
    end

    describe '#lowest_bid_amount' do
      it "should return '-'" do
        expect(subject.lowest_bid_amount).to eq '-'
      end
    end

    describe '#lowest_bid_creditor' do
      it "should return '-'" do
        expect(subject.lowest_bid_creditor).to eq '-'
      end
    end
  end

  context 'when lowest_bid is present' do
    before do
      component.stub(
        lowest_bid: double(:lowest_bid, amount: 10.0,
                                   accreditation_creditor: 'creditor'))
    end

    describe '#lowest_bid_amount' do
      it "should return the amount with precision" do
        expect(subject.lowest_bid_amount).to eq '10,00'
      end
    end

    describe '#lowest_bid_creditor' do
      it "should return the creditor" do
        expect(subject.lowest_bid_creditor).to eq 'creditor'
      end
    end
  end

  describe '#lowest_proposal_amount' do
    context 'when lowest_proposal is nil' do
      before do
        component.stub(lowest_proposal: nil)
      end

      it 'should return "-"' do
        expect(subject.lowest_proposal_amount).to eq '-'
      end
    end

    context 'when lowest_proposal is not nil' do
      let(:proposal) { double(:proposal, unit_price: 1234.56) }

      before do
        component.stub(lowest_proposal: proposal)
      end

      it 'should return proposal unit_price with precision' do
        expect(subject.lowest_proposal_amount).to eq '1.234,56'
      end
    end
  end

  describe '#lowest_proposal_creditor' do
    context 'when lowest_proposal is nil' do
      before do
        component.stub(lowest_proposal: nil)
      end

      it 'should return "-"' do
        expect(subject.lowest_proposal_creditor).to eq '-'
      end
    end

    context 'when lowest_proposal is not nil' do
      let(:proposal) { double(:proposal, creditor: 'creditor') }

      before do
        component.stub(lowest_proposal: proposal)
      end

      it "should return proposal's creditor" do
        expect(subject.lowest_proposal_creditor).to eq 'creditor'
      end
    end
  end
end
