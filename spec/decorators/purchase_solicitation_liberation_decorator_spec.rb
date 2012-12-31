# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_liberation_decorator'

describe PurchaseSolicitationLiberationDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have budget_structure, creditor and status' do
      expect(described_class.header_attributes).to include :sequence
      expect(described_class.header_attributes).to include :responsible
      expect(described_class.header_attributes).to include :date
      expect(described_class.header_attributes).to include :service_status
    end
  end
end
