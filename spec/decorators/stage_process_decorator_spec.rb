require 'decorator_helper'
require 'app/decorators/stage_process_decorator'

describe StageProcessDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description, type_of_purchase' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :type_of_purchase
    end
  end
end
