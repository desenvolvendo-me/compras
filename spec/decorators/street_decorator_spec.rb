# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/street_decorator'

describe StreetDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, type and city' do
      expect(described_class.header_attributes).to include :name, :street_type, :city
    end
  end
end
