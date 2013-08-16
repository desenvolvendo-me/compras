require 'report_helper'
require 'decore'
require 'app/reports/map_of_price_report'

describe MapOfPriceReport do
  let :price_collection_proposal_item_repository do
    double(:price_collection_proposal_item)
  end

  subject do
    described_class.new price_collection_proposal_item_repository
  end

  let(:item_1) { double(:item_proposal_1) }
  let(:item_2) { double(:item_proposal_2) }
  let(:records) { [item_1, item_2] }

  describe '#item_proposals_grouped_by_lot' do
    before { subject.stub(:records).and_return records }

    it 'returns the item proposals grouped by lot' do
      expect(subject.records).to receive(:group_by).and_yield(item_1).and_yield(item_2)
      expect(subject).to receive(:lot_group).with(item_1)
      expect(subject).to receive(:lot_group).with(item_2)

      subject.item_proposals_grouped_by_lot
    end
  end

  describe '#price_collection' do
    before { subject.stub(:records).and_return records }

    it 'returns the price collection of the first record' do
      item_1.stub(:price_collection).and_return 'price_collection'

      expect(subject.price_collection).to eql 'price_collection'
    end
  end

  describe '#lot_group' do
    before do
      item_1.stub(:lot).and_return 'Lot 1'
      item_1.stub(:material).and_return 'Material 1'
    end

    it 'returns the item lot and item material string' do
      expect(subject.send(:lot_group, item_1)).to eql 'Lot 1 - Material 1'
    end
  end
end
