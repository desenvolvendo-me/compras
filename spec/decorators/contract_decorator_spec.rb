# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/contract_decorator'

describe ContractDecorator do
  it 'should return formatted total pledges value as currency' do
    component.stub(:pledges_total_value => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledges_total_value.should eq 'R$ 100,00'
  end
end
