require 'report_helper'
require 'decore'
require 'app/reports/map_of_bid_report'

describe MapOfBidReport do
  let :map_of_bids_searcher_repository do
    double(:map_of_bids_searcher_repository)
  end
  let(:purchase_process) { double('purchase_process', id: 1, creditor_proposals: creditor_proposals) }
  let(:purchase_process_trading) { double('PurchaseProcessTrading', id: 1, purchase_process: purchase_process, items: items) }
  let(:item) { double('PurchaseProcessItem', id: 1, unit_price: 5.99, quantity: 2) }
  let(:proposal) { double('PurchaseProcessCreditorProposal', id: 1) }
  let(:proposal_two) { double('PurchaseProcessCreditorProposal', id: 2) }
  let(:creditor_proposals) { double('PurchaseProcessCreditorProposal', by_item_id: [proposal]) }
  let(:trading_item) { double('PurchaseProcessTradingItem', id: 1) }
  let(:trading_item_two) { double('PurchaseProcessTradingItem', id: 2) }
  let(:items) { [trading_item] }

  subject do
    described_class.new map_of_bids_searcher_repository, licitation_process_id: purchase_process.id
  end

  context 'when have a trading' do
    before do
      map_of_bids_searcher_repository.should_receive(:search).at_least(1).times.
        with(licitation_process: 1).and_return [purchase_process_trading]
    end

    it '#records' do
      expect(subject.records).to eq [purchase_process_trading]
    end

    it '#purchase_process' do
      expect(subject.purchase_process).to eq purchase_process
    end

    it '#trading_items' do
      expect(subject.trading_items).to include (trading_item)
      expect(subject.trading_items).to_not include (trading_item_two)
    end

    it '#proposals_by_item' do
      expect(subject.proposals_by_item(item)).to include (proposal)
    end
  end

  describe '#average_unit_price_item' do
    context 'when item is nil' do
      it 'should return nil' do
        expect(subject.average_unit_price_item(nil)).to eq nil
      end
    end

    context 'when item is not nil' do
      it 'should return unit_price' do
        expect(subject.average_unit_price_item(item)).to eq 5.99
      end
    end
  end

  describe '#average_total_price_item' do
    context 'when item is nil' do
      it 'should return nil' do
        expect(subject.average_total_price_item(nil)).to eq nil
      end
    end

    context 'when item is not nil' do
      it 'should return total price' do
        expect(subject.average_total_price_item(item)).to eq 11.98
      end
    end
  end
end
