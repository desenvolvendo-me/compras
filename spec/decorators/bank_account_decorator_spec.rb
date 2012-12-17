# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/bank_account_decorator'

describe BankAccountDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and status' do
      expect(described_class.header_attributes).to include :bank
      expect(described_class.header_attributes).to include :agency
      expect(described_class.header_attributes).to include :account_number
      expect(described_class.header_attributes).to include :status
    end
  end
end
