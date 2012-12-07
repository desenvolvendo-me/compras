# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/document_type_decorator'

describe DocumentTypeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and validity' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :validity
    end
  end
end
