# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reserve_fund_decorator'

describe ReserveFundDecorator do
  it 'should return budget_allocation_amount with precision' do
    component.stub(:budget_allocation_amount).and_return(5000.0)
    helpers.stub(:number_with_precision).with(5000.0).and_return("5.000,00")

    subject.budget_allocation_amount.should eq '5.000,00'
  end
end
