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
end
