# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/materials_class_decorator'

describe MaterialsClassDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and class_number' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :class_number
    end
  end
end
