# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/risk_degree_decorator'

describe RiskDegreeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name and level' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :level
    end
  end
end
