require 'decorator_helper'
require 'app/decorators/material_decorator'

describe MaterialDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description, code, material_group and material_class' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :code
      expect(described_class.header_attributes).to include :material_class
    end
  end
end
