# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/neighborhood_decorator'

describe NeighborhoodDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name and city' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :city
    end
  end
end
