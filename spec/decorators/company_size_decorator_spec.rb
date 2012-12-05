# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/company_size_decorator'

describe CompanySizeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, acronym and country' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :acronym
    end
  end
end
