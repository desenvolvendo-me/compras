require 'presenter_helper'
require 'app/presenters/subpledge_presenter'

describe SubpledgePresenter do
  subject do
    described_class.new(subpledge, nil, helpers)
  end

  let :subpledge do
    double('Subpledge')
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

  it 'should return formatted emission date' do
    subpledge.stub(:emission_date).and_return(date)
    subject.emission_date.should eq '01/12/2012'
  end

  it 'should return formatted pledge_value' do
    subpledge.stub(:pledge_value).and_return(9.99)
    subject.pledge_value.should eq '9,99'
  end

  it 'should return formatted balance' do
    subpledge.stub(:balance).and_return(9.99)
    subject.balance.should eq '9,99'
  end
end
