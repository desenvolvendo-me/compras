# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/materials_group_decorator'

describe MaterialsGroupDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and group_number' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :group_number
    end
  end
end
