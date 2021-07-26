# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/map_of_price_report_decorator'

describe MapOfPriceReportDecorator do
  let(:lot)             { double(:lot) }
  let(:proposal_item_1) { double(:proposal_item_1)}
  let(:proposal_item_2) { double(:proposal_item_2)}
  let(:proposal_items)  { [proposal_item_1, proposal_item_2] }
  let(:creditor)        { double(:creditor) }

  describe '#lot_header' do
    before { lot.stub(:to_s).and_return 'Lot 1' }

    it 'returns the item lot and quantity as string' do
      expect(subject.lot_header(lot, proposal_items)).to eql 'Lote: Lot 1 - Quantidade: 2'
    end
  end

  describe '#creditor_data' do
    before do
      creditor.stub(:identity_document).and_return '12345'
      creditor.stub(:name).and_return 'Foo Bar'
    end

    it 'returns the creditor documento and name as string' do
      expect(subject.creditor_data(creditor)).to eql '12345 - Foo Bar'
    end
  end

  describe '#item_unit_price' do
    before { proposal_item_1.stub(:unit_price).and_return 11.99 }

    it 'returns the item unit price as currency' do
      expect(subject.item_unit_price(proposal_item_1)).to eql 'R$ 11,99'
    end
  end

  describe '#item_total_price' do
    before { proposal_item_1.stub(:total_price).and_return 35.99 }

    it 'returns the item unit price as currency' do
      expect(subject.item_total_price(proposal_item_1)).to eql 'R$ 35,99'
    end
  end

  describe '#item_average_unit_price' do
    it 'returns the items average unit price as currency' do
      proposal_items.should_receive(:sum).and_return 25.58
      expect(subject.item_average_unit_price(proposal_items)).to eql 'R$ 12,79'
    end
  end

  describe '#item_average_total_price' do
    it 'returns the items average total price as currency' do
      proposal_items.should_receive(:sum).and_return 51.58
      expect(subject.item_average_total_price(proposal_items)).to eql 'R$ 25,79'
    end
  end
end
