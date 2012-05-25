# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/pledge_decorator'

describe PledgeDecorator do
  it 'should return budget_allocation_real_amount with precision' do
    component.stub(:budget_allocation_real_amount => 500.0)
    helpers.stub(:number_with_precision).with(500.0).and_return("500,00")

    subject.budget_allocation_real_amount.should eq '500,00'
  end

  it 'should return reserve_fund_value with precision' do
    component.stub(:reserve_fund_value => 300.0)
    helpers.stub(:number_with_precision).with(300.0).and_return("300,00")

    subject.reserve_fund_value.should eq '300,00'
  end

  it 'should return formatted balance' do
    component.stub(:balance => 100.0)
    helpers.stub(:number_with_precision).with(100.0).and_return("100,00")

    subject.balance.should eq '100,00'
  end

  it 'should return formatted pledge_liquidations_sum' do
    component.stub(:pledge_liquidations_sum => 100.0)
    helpers.stub(:number_with_precision).with(100.0).and_return('100,00')

    subject.pledge_liquidations_sum.should eq '100,00'
  end

  it 'should return formatted balance as currency' do
    component.stub(:balance => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.balance_as_currency.should eq 'R$ 100,00'
  end

  it 'should return formatted pledge_cancellations_sum as currency' do
    component.stub(:pledge_cancellations_sum => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledge_cancellations_sum.should eq 'R$ 100,00'
  end

  it 'should return formatted pledge_liquidations_sum as currency format' do
    component.stub(:pledge_liquidations_sum => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledge_liquidations_sum_as_currency.should eq 'R$ 100,00'
  end

  it 'should return formatted value as currency' do
    component.stub(:value => 100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.value.should eq 'R$ 100,00'
  end
end
