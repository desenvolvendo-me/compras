require 'decorator_helper'
require 'app/decorators/subpledge_cancellation_decorator'

describe SubpledgeCancellationDecorator do
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

  it 'should return formatted subpledge_balance' do
    component.stub(:subpledge_balance).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.subpledge_balance.should eq '9,99'
  end

  it 'should return formatted subpledge_expiration_balance' do
    component.stub(:subpledge_expiration_balance).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.subpledge_expiration_balance.should eq '9,99'
  end
end
