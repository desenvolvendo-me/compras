# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/regulatory_act_type_decorator'

describe RegulatoryActTypeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and regulatory_act_type_classification' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :regulatory_act_type_classification
    end
  end
end
