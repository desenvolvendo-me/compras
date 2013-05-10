require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/trading_item_bid_status'
require 'app/business/trading_bid_creator'

describe TradingBidCreator do
  let(:trading) { double(:trading, id: 2) }
  let(:bids) { double(:bids, with_proposal: with_proposal) }
  let(:item) { double(:item, id: 10, lot: 1, trading_bids: bids) }
  let(:bid_repository) { double(:bid_repository) }
  let(:with_proposal) { double(:with_proposal) }
  let(:by_item_id) { double(:by_item_id, with_proposal: with_proposal) }
  let(:creditor) { double(:creditor, id: 5) }

  subject do
    described_class.new(trading, item, bid_repository: bid_repository)
  end

  context 'when bids are empty' do
    before do
      bids.stub(empty?: true)
    end

    it 'should create bids for creditors' do
      subject.stub(:last_round => 0)
      item.should_receive(:trading_creditors_selected).and_return([creditor])

      bid_repository.
        should_receive(:create!).
        with(round: 1, purchase_process_accreditation_creditor_id: 5,
             status: TradingItemBidStatus::WITHOUT_PROPOSAL, amount: 0,
             purchase_process_item_id: 10, lot: 1, purchase_process_trading_id: 2)

      subject.create!
    end
  end

  context 'when bids are not empty' do
    before do
      bids.stub(empty?: false)
    end

    context 'when not all bidders gave a bid for current round' do
      before do
        subject.stub(creditors_without_bid_for_last_round: [creditor])
      end

      it 'should do nothing' do
        bid_repository.should_not_receive(:create!)

        subject.create!
      end
    end

    context 'when all bidders gave a bid for current round' do
      before do
        subject.stub(creditors_without_bid_for_last_round: [])
      end

      it 'should create bids for next round' do
        creditor2 = double(:creditor2, id: 34)

        subject.stub(last_round: 1)
        subject.stub(creditors_with_bid_for_last_round: [creditor, creditor2])

        bid_repository.
          should_receive(:create!).
          with(round: 2, purchase_process_accreditation_creditor_id: 5,
               status: TradingItemBidStatus::WITHOUT_PROPOSAL, amount: 0,
               purchase_process_item_id: 10, lot: 1, purchase_process_trading_id: 2)

        bid_repository.
          should_receive(:create!).
          with(round: 2, purchase_process_accreditation_creditor_id: 34,
               status: TradingItemBidStatus::WITHOUT_PROPOSAL, amount: 0,
               purchase_process_item_id: 10, lot: 1, purchase_process_trading_id: 2)

        subject.create!
      end
    end
  end

  describe '.create_items_bids!' do
    it "should generate bids for all trading's items" do
      item2     = double(:item2)
      instance1 = double(:instance1)
      instance2 = double(:instance2)

      trading.stub(items: [item, item2])

      described_class.should_receive(:new).with(trading, item).and_return(instance1)
      described_class.should_receive(:new).with(trading, item2).and_return(instance2)

      instance1.should_receive(:create!)
      instance2.should_receive(:create!)

      described_class.create_items_bids!(trading)
    end
  end
end
