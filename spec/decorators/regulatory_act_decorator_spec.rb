# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/regulatory_act_decorator'

describe RegulatoryActDecorator do
  before do
    component.stub(:creation_date).and_return(Date.new(2012, 8, 13))
  end

  it 'should return correct summary' do
    expect(subject.summary).to eq 'Criado em 13/08/2012'
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have regulatory_act_type, act_number and creation_date' do
      expect(described_class.header_attributes).to include :regulatory_act_type
      expect(described_class.header_attributes).to include :act_number
      expect(described_class.header_attributes).to include :creation_date
    end
  end
end
