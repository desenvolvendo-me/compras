# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/budget_allocation_decorator'

describe BudgetAllocationDecorator do
  it 'should return real_amount with precision' do
    component.stub(:real_amount => 500.0)
    helpers.stub(:number_with_precision).with(500.0).and_return("500,00")

    subject.real_amount.should eq '500,00'
  end

  it 'should return reserved_value with precision' do
    component.stub(:reserved_value => 500.0)
    helpers.stub(:number_with_precision).with(500.0).and_return("500,00")

    subject.reserved_value.should eq '500,00'
  end

  it 'should return description as summary' do
    component.stub(:description => 'Alocação')
    subject.summary.should eq 'Alocação'
  end
end
