# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/country_decorator'

describe CountryDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name' do
      expect(described_class.header_attributes).to include :name
    end
  end
end
