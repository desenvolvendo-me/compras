require 'decorator_helper'
require 'app/decorators/condominium_decorator'

describe CondominiumDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :condominium_type
    end
  end
end
