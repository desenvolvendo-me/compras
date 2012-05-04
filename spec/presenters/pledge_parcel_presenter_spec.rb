require 'presenter_helper'
require 'app/presenters/pledge_parcel_presenter'

describe PledgeParcelPresenter do
  subject do
    described_class.new(pledge_parcel, nil, helpers)
  end

  let :pledge_parcel do
    double
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :pledge_cancellation do
    double
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return emission date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')
    pledge_parcel.stub(:emission_date).and_return(date)

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return pledge_parcel_value' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    pledge_parcel.stub(:pledge_value).and_return(9.99)

    subject.pledge_value.should eq '9,99'
  end

  it 'should return canceled_value' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    pledge_parcel.stub(:canceled_value).and_return(9.99)

    subject.canceled_value.should eq '9,99'
  end

  it 'should return balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    pledge_parcel.stub(:balance).and_return(9.99)

    subject.balance.should eq '9,99'
  end

  it 'should return formatted balance as currency' do
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    pledge_parcel.stub(:balance).and_return(9.99)

    subject.balance_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted value as currency' do
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    pledge_parcel.stub(:value).and_return(9.99)

    subject.value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted canceled_value as currency' do
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    pledge_parcel.stub(:canceled_value).and_return(9.99)

    subject.canceled_value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted liquidations_value as currency' do
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    pledge_parcel.stub(:liquidations_value).and_return(9.99)

    subject.liquidations_value_as_currency.should eq 'R$ 9,99'
  end

  it 'should return formatted canceled_liquidations_value as currency' do
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    pledge_parcel.stub(:canceled_liquidations_value).and_return(9.99)

    subject.canceled_liquidations_value_as_currency.should eq 'R$ 9,99'
  end
end
