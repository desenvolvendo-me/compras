require 'presenter_helper'
require 'app/presenters/pledge_liquidation_presenter'

describe PledgeLiquidationPresenter do
  subject do
    described_class.new(pledge_liquidation, nil, helpers)
  end

  let :pledge_liquidation do
    double
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('01/12/2012')
      helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    end
  end

  it 'should return emission date' do
    pledge_liquidation.stub(:emission_date).and_return(date)
    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return expiration_date' do
    pledge_liquidation.stub(:expiration_date).and_return(date)
    subject.expiration_date.should eq '01/12/2012'
  end

  it 'should return balance' do
    pledge_liquidation.stub(:balance).and_return(9.99)
    subject.balance.should eq '9,99'
  end

  it 'should return expiration_date' do
    pledge_liquidation.stub(:pledge_value).and_return(9.99)
    subject.pledge_value.should eq '9,99'
  end
end
