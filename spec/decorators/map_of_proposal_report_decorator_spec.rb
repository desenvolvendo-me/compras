require 'decorator_helper'
require 'app/decorators/map_of_proposal_report_decorator'

describe MapOfProposalReportDecorator do
  let(:item) { double('PurchaseProcessItem', id: 1) }
  describe '#average_unit_price_item' do
    it 'returns the formatted item unit price' do
      component.stub(:average_unit_price_item).and_return 1000.12
      expect(subject.average_unit_price_item(item)).to eql "R$ 1.000,12"
    end
  end

  describe '#average_total_price_item' do
    it 'returns the formatted average total price' do
      component.stub(:average_total_price_item).and_return 11000.12
      expect(subject.average_total_price_item(item)).to eql "R$ 11.000,12"
    end
  end
end
