require 'decorator_helper'
require 'app/decorators/street_type_decorator'

describe StreetTypeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name and acronym' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :acronym
    end
  end
end
