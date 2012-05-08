require 'presenter_helper'
require 'app/presenters/subpledge_cancellation_presenter'

describe SubpledgeCancellationPresenter do
  subject do
    described_class.new(subpledge_cancellation, nil, helpers)
  end

  let :subpledge_cancellation do
    double('SubpledgeCancellation', {
      :subpledge_balance => 9.99,
      :emission_date => date,
      :pledge_value => 9.99,
      :subpledge_expiration_balance => 9.99
    })
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double('helpers')
  end

  it 'should return formatted emission date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return formatted pledge_value' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.pledge_value.should eq '9,99'
  end

  it 'should return formatted subpledge_balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.subpledge_balance.should eq '9,99'
  end

  it 'should return formatted subpledge_expiration_balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.subpledge_expiration_balance.should eq '9,99'
  end
end
