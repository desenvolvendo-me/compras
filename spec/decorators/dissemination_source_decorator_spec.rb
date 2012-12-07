# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/dissemination_source_decorator'

describe DisseminationSourceDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and communication_source' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :communication_source
    end
  end
end
