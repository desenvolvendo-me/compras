require 'decorator_helper'
require 'app/decorators/pledge_liquidation_decorator'

describe PledgeLiquidationDecorator do
  let :date do
    Date.new(2012, 12, 1)
  end

  it 'should return emission date' do
    component.stub(:emission_date).and_return(date)
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return expiration_date' do
    component.stub(:expiration_date).and_return(date)
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.expiration_date.should eq '01/12/2012'
  end

  it 'should return balance' do
    component.stub(:balance).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.balance.should eq '9,99'
  end

  it 'should return pledge_value' do
    component.stub(:pledge_value).and_return(10.0)
    helpers.stub(:number_to_currency).with(10.0).and_return('R$ 10,00')

    subject.pledge_value.should eq 'R$ 10,00'
  end

  it 'should return pledge_balance' do
    component.stub(:pledge_balance).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledge_balance.should eq 'R$ 100,00'
  end

  it 'should return pledge_liquidations_sum' do
    component.stub(:pledge_liquidations_sum).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledge_liquidations_sum.should eq 'R$ 100,00'
  end

  it 'should return pledge_cancellations_sum' do
    component.stub(:pledge_cancellations_sum).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.pledge_cancellations_sum.should eq 'R$ 100,00'
  end

  it 'should return parcels_sum' do
    component.stub(:parcels_sum).and_return(10.0)
    helpers.stub(:number_with_precision).with(10.0).and_return('10,00')

    subject.parcels_sum.should eq '10,00'
  end

  it 'should return value' do
    component.stub(:value).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.value.should eq 'R$ 100,00'
  end
end
