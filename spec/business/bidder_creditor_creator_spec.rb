require 'unit_helper'
require 'app/business/bidder_creditor_creator'

describe BidderCreditorCreator do
  let(:creditor_one) { double('Creditor', id: 5) }
  let(:purchase_process) { double('LicitationProcess', id: 1) }
  let(:trading_item_winner) { double(:trading_item_winner) }

  describe "#create_bidders" do
    subject do
      described_class.new(purchase_process, trading_item_winner: trading_item_winner)
    end

    context 'when direct purchase' do
      let(:item_one) { double('PurchaseProcessItem', id: 1, creditor: creditor_one, creditor_id: creditor_one.id) }

      before do
        purchase_process.stub(
          creditors: [creditor_one],
          items: [item_one],
          direct_purchase?: true,
          trading?: false)
      end

      context "when bidders is empty" do
        before do
          purchase_process.stub(bidders: [])
        end

        xit "should create a bidders" do

          purchase_process.bidders.should_receive(:create!).
            with(licitation_process_id: purchase_process.id, creditor_id: creditor_one.id)

          subject.create_bidders!
        end
      end

      context "when bidders is not empty" do
        before do
          purchase_process.stub(bidders: [:creditor_one])
        end

        xit 'should not create bidders' do
          purchase_process.bidders.should_not_receive(:create!)

          subject.create_bidders!
        end
      end
    end

    context 'when trading' do
      let(:item) { double(:item) }
      let(:items) { double(:items, closed: [item]) }
      let(:bidders) { double(:bidders) }
      let(:trading) { double(:trading, items: items) }

      before do
        purchase_process.stub(
          trading: trading,
          direct_purchase?: false,
          trading?: true,
          bidders: bidders)
      end

      context 'when bidders is empty' do
        before do
          bidders.stub(empty?: true)
        end

        xit 'should create the bids based on creditors who win the trading item' do
          trading_item_winner.should_receive(:new).with(item).and_return(trading_item_winner)
          trading_item_winner.should_receive(:creditor).and_return(creditor_one)

          bidders.should_receive(:create!).with(licitation_process_id: 1, creditor_id: 5)

          subject.create_bidders!
        end
      end

      context 'when bidders is not empty' do
        before do
          bidders.stub(empty?: false)
        end

        it 'should do nothing' do
          bidders.should_not_receive(:create!)

          subject.create_bidders!
        end
      end
    end
  end
end
