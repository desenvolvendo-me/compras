require 'decorator_helper'
require 'app/decorators/supply_order_decorator'

describe SupplyOrderDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have creditor, authorization_date and licitation_process' do
      expect(described_class.header_attributes).to include :creditor
      expect(described_class.header_attributes).to include :authorization_date
      expect(described_class.header_attributes).to include :licitation_process
    end
  end
end
