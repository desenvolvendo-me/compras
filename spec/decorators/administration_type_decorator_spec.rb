# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/administration_type_decorator'

describe AdministrationTypeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description, administration and organ_type' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :administration
      expect(described_class.header_attributes).to include :organ_type
    end
  end
end

