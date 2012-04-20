# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_expiration'
require 'app/models/pledge_cancellation'
require 'app/models/pledge_liquidation'

describe PledgeExpiration do
  it { should belong_to :pledge }
  it { should have_many(:pledge_cancellations).dependent(:restrict) }
  it { should have_many(:pledge_liquidations).dependent(:restrict) }

  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }

  it 'should return correct balance value' do
    subject.value = 10
    subject.stub(:canceled_value).and_return(2)
    subject.stub(:liquidations_value).and_return(3)
    subject.balance.should eq 5
  end
end
