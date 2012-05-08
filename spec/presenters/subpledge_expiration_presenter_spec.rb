require 'presenter_helper'
require 'app/presenters/subpledge_expiration_presenter'

describe SubpledgeExpirationPresenter do
  subject do
    described_class.new(subpledge_expiration, nil, helpers)
  end

  let :subpledge_expiration do
    double('SubpledgeExpiration', :balance => 9.99)
  end

  let :helpers do
    double('Helpers')
  end

  it 'should return formatted balance' do
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.balance.should eq '9,99'
  end
end
