# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/delivery_location_decorator'

describe DeliveryLocationDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description, street and number' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :street
      expect(described_class.header_attributes).to include :number
    end
  end
end
