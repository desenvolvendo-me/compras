# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/regularization_or_administrative_sanction_reason_decorator'

describe RegularizationOrAdministrativeSanctionReasonDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and reason_type' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :reason_type
    end
  end
end
