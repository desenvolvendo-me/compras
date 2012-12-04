# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/city_decorator'

describe CityDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, state and code' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :state
      expect(described_class.header_attributes).to include :code
    end
  end
end
