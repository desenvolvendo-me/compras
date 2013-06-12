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

  describe '#reduction_rate_value' do
    context 'when reduction_rate_value' do
      before do
        component.stub(reduction_rate_value: 10.12)
      end

      it 'should return number with precision' do
        expect(subject.reduction_rate_value).to eq '10,12'
      end
    end

    context 'when has not reduction_rate_value' do
      before do
        component.stub(reduction_rate_value: nil)
      end

      it 'should return 0,00' do
        expect(subject.reduction_rate_value).to eq '0,00'
      end
    end
  end

  describe '#reduction_rate_percent' do
    context 'when reduction_rate_percent' do
      before do
        component.stub(reduction_rate_percent: 10.12)
      end

      it 'should return number with precision' do
        expect(subject.reduction_rate_percent).to eq '10,12'
      end
    end

    context 'when has not reduction_rate_percent' do
      before do
        component.stub(reduction_rate_percent: nil)
      end

      it 'should return 0,00' do
        expect(subject.reduction_rate_percent).to eq '0,00'
      end
    end
  end

  describe '#total_price' do
    context 'when lowest_proposal is nil' do
      before do
        component.stub(lowest_proposal: nil)
      end

      it 'returns "-"' do
        expect(subject.total_price).to eq '-'
      end
    end

    context 'when lowest_proposal is not nil' do
      let(:proposal) { double(:proposal, unit_price: 10) }

      before do
        component.stub(quantity: 5)
        component.stub(lowest_proposal: proposal)
      end

      it "returns proposal's total_price" do
        expect(subject.total_price).to eq '50,00'
      end
    end
  end
end
