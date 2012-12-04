# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/bank_decorator'

describe BankDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, code and acronym' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :code
      expect(described_class.header_attributes).to include :acronym
    end
  end
end
