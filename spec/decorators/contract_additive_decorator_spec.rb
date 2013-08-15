require 'decorator_helper'
require 'app/decorators/contract_additive_decorator'

describe ContractAdditiveDecorator do
  context "with attr_header" do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have number, additive_type and signature_date' do
      expect(described_class.header_attributes).to include :number
      expect(described_class.header_attributes).to include :additive_type
      expect(described_class.header_attributes).to include :signature_date
    end
  end
end
