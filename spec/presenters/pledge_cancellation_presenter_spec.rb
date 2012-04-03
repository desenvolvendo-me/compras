require 'presenter_helper'
require 'app/presenters/pledge_cancellation_presenter'

describe PledgeCancellationPresenter do
  subject do
    described_class.new(pledge_cancellation, nil, helpers)
  end

  let :pledge_cancellation do
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
    pledge_cancellation.stub(:emission_date).and_return(date)
    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return expiration_date' do
    pledge_cancellation.stub(:expiration_date).and_return(date)
    subject.expiration_date.should eq '01/12/2012'
  end

  it 'should return canceled_value' do
    pledge_cancellation.stub(:canceled_value).and_return(9.99)
    subject.canceled_value.should eq '9,99'
  end

  it 'should return expiration_date' do
    pledge_cancellation.stub(:pledge_value).and_return(9.99)
    subject.pledge_value.should eq '9,99'
  end
end
