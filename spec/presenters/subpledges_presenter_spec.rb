require 'presenter_helper'
require 'app/presenters/subpledge_presenter'

describe SubpledgePresenter do
  subject do
    described_class.new(subpledge, nil, helpers)
  end

  let :subpledge do
    double('Subpledge', :balance => 100, :pledge_balance => 10, :emission_date => date, :pledge_value => 9.99, :pledge_balance => 9.99)
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return formatted emission date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return formatted pledge_value' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.pledge_value.should eq '9,99'
  end

  it 'should return formatted pledge_balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.pledge_balance.should eq '9,99'
  end

  it 'should return formatted balance' do
    helpers.stub(:number_with_precision).with(100).and_return('100,00')

    subject.balance.should eq '100,00'
  end
end
