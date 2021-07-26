require 'decorator_helper'
require 'app/decorators/holiday_decorator'

describe HolidayDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, date and recurrent' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :date
      expect(described_class.header_attributes).to include :recurrent
    end
  end
end
