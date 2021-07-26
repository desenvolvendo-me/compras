require 'spec_helper'

describe PurchaseProcessTradingsHelper do
  describe '#make_bid_disabled_message' do
    let(:next_bid) { double(:next_bid) }

    context 'when next_bid is blank' do
      it 'should return the message' do
        expect(helper.make_bid_disabled_message(nil)).to eq 'todos os lances já foram efetuados'
      end
    end

    context 'when next_bid is not blank' do
      it 'should not return the message' do
        expect(helper.make_bid_disabled_message(next_bid)).to be_nil
      end
    end
  end

  describe '#undo_bid_disabled_message' do
    context 'when historic is empty' do
      it 'should return the message' do
        expect(helper.undo_bid_disabled_message([])).to eq 'não há lance para ser desfeito'
      end
    end

    context 'when historic is not empty' do
      it 'should return the message' do
        expect(helper.undo_bid_disabled_message(['bid'])).to be_nil
      end
    end
  end

  describe '#amount_with_reduction'do
    context 'when next_bid is nil' do
      it 'should return 0,00' do
        expect(helper.amount_with_reduction(nil)).to eq '0,00'
      end
    end

    context 'when next_bid is not nil' do
      let(:next_bid) { double(:next_bid) }
      let(:decorator) { double(:decorator) }

      it "should return calls the decorator's amount_with_reduction method" do
        next_bid.should_receive(:decorator).and_return(decorator)
        decorator.should_receive(:amount_with_reduction).and_return('100,50')

        expect(helper.amount_with_reduction(next_bid)).to eq '100,50'
      end
    end
  end
end
