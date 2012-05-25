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
end
