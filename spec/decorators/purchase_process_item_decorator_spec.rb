require 'decorator_helper'
require 'app/decorators/purchase_process_item_decorator'

describe PurchaseProcessItemDecorator do
  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_price).to be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(9.99)
      end

      it 'should applies precision' do
        expect(subject.total_price).to eq 'R$ 9,99'
      end
    end
  end

  context '#unit_price' do
    context 'when do not have unit_price' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price).to be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(9.99)
      end

      it 'should applies currency' do
        expect(subject.unit_price).to eq '9,99'
      end
    end
  end

  context '#unit_price_by_bidder' do
    context 'when unit_price_by_bider is nil' do
      before do
        component.stub(:unit_price_by_bidder).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price_by_bidder(nil)).to be_nil
      end
    end

    context 'when have unit_price_by_bidder' do
      before do
        component.stub(:unit_price_by_bidder).and_return 330.0
      end

      it 'should applies currency' do
        expect(subject.unit_price_by_bidder(nil)).to eq '330,00'
      end
    end
  end

  context '#total_value_by_bidder' do
    context 'when total_value_by_bidder is nil' do
      before do
        component.stub(:total_value_by_bidder).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_value_by_bidder(nil)).to be_nil
      end
    end

    context 'when total_value_by_bidder has value' do
      before do
        component.stub(:total_value_by_bidder).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.total_value_by_bidder(nil)).to eq '220,00'
      end
    end
  end

  context '#quantity' do
    context 'when quantity is nil' do
      before do
        component.stub(:quantity).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.quantity).to be_nil
      end
    end

    context 'when quantity has value' do
      before do
        component.stub(:quantity).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.quantity).to eq '220,00'
      end
    end
  end

  context 'when lowest_trading_bid is not present' do
    before do
      component.stub(lowest_trading_bid: nil)
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

  context 'when lowest_trading_bid is present' do
    before do
      component.stub(
        lowest_trading_bid: double(:lowest_trading_bid, amount: 10.0,
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
    context 'when trading_lowest_proposal is nil' do
      before do
        component.stub(trading_lowest_proposal: nil)
      end

      it 'should return "-"' do
        expect(subject.lowest_proposal_amount).to eq '-'
      end
    end

    context 'when trading_lowest_proposal is not nil' do
      let(:proposal) { double(:proposal, unit_price: 1234.56) }

      before do
        component.stub(trading_lowest_proposal: proposal)
      end

      it 'should return proposal unit_price with precision' do
        expect(subject.lowest_proposal_amount).to eq '1.234,56'
      end
    end
  end

  describe '#lowest_proposal_creditor' do
    context 'when trading_lowest_proposal is nil' do
      before do
        component.stub(trading_lowest_proposal: nil)
      end

      it 'should return "-"' do
        expect(subject.lowest_proposal_creditor).to eq '-'
      end
    end

    context 'when trading_lowest_proposal is not nil' do
      let(:proposal) { double(:proposal, creditor: 'creditor') }

      before do
        component.stub(trading_lowest_proposal: proposal)
      end

      it "should return proposal's creditor" do
        expect(subject.lowest_proposal_creditor).to eq 'creditor'
      end
    end
  end
end
