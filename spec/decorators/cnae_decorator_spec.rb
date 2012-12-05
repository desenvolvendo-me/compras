# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/cnae_decorator'

describe CnaeDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name, code and risk_degree' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :code
      expect(described_class.header_attributes).to include :risk_degree
    end
  end
end
