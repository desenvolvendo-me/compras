require 'presenter_helper'
require 'app/presenters/pledge_expiration_presenter'

describe PledgeExpirationPresenter do
  subject do
    described_class.new(pledge_expiration, nil, helpers)
  end

  let :pledge_expiration do
    double
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('01/12/2012')
      helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
      helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    end
  end

  it 'should return emission date' do
    pledge_expiration.stub(:emission_date).and_return(date)
    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return pledge_expiration_value' do
    pledge_expiration.stub(:pledge_value).and_return(9.99)
    subject.pledge_value.should eq '9,99'
  end

  it 'should return canceled_value' do
    pledge_expiration.stub(:canceled_value).and_return(9.99)
    subject.canceled_value.should eq '9,99'
  end

  it 'should return balance' do
    pledge_expiration.stub(:balance).and_return(9.99)
    subject.balance.should eq '9,99'
  end

  it 'should return formatted balance as currency' do
    pledge_expiration.stub(:balance).and_return(9.99)
    subject.balance_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted value as currency' do
    pledge_expiration.stub(:value).and_return(9.99)
    subject.value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted canceled_value as currency' do
    pledge_expiration.stub(:canceled_value).and_return(9.99)
    subject.canceled_value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted liquidations_value as currency' do
    pledge_expiration.stub(:liquidations_value).and_return(9.99)
    subject.liquidations_value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted canceled_liquidations_value as currency' do
    pledge_expiration.stub(:canceled_liquidations_value).and_return(9.99)
    subject.canceled_liquidations_value_as_currency.should eq 'R$ 9,99'
  end
end
