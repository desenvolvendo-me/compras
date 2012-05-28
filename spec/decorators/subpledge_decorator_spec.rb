require 'decorator_helper'
require 'app/decorators/subpledge_decorator'

describe SubpledgeDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  it 'should return formatted emission date' do
    component.stub(:emission_date).and_return(date)
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return formatted pledge_value' do
    component.stub(:pledge_value).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.pledge_value.should eq '9,99'
  end

  it 'should return formatted balance' do
    component.stub(:balance).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.balance.should eq '9,99'
  end

  it 'should return formatted balance as currency' do
    component.stub(:balance).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.balance_as_currency.should eq 'R$ 100,00'
  end

  it 'should return formatted value as currency' do
    component.stub(:value).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.value.should eq 'R$ 100,00'
  end

  it 'should return formatted subpledge_cancellations_sum' do
    component.stub(:subpledge_cancellations_sum).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.subpledge_cancellations_sum.should eq 'R$ 100,00'
  end
end
