require 'decorator_helper'
require 'app/decorators/customization_decorator'

describe CustomizationDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have state and model' do
      expect(described_class.header_attributes).to include :state
      expect(described_class.header_attributes).to include :model
    end
  end
end
