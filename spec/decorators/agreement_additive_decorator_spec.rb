# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/agreement_additive_decorator'

describe AgreementAdditiveDecorator do
  before do
    component.stub(:year).and_return(2011)
    component.stub(:number).and_return(2)
  end

  it 'should return correct summary' do
    expect(subject.number_and_year).to eq '2/2011'
  end
end
