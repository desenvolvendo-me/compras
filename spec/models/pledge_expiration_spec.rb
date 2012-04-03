# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_expiration'
require 'app/models/pledge_cancellation'

describe PledgeExpiration do
  it { should belong_to :pledge }
  it { should have_many(:pledge_cancellations).dependent(:restrict) }

  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }

  it 'should return canceled_value as sum of all pledge_cancellations' do
    pledge_cancellations = [double(:value => 1), double(:value => 3.99)]
    subject.stub(:pledge_cancellations).and_return(pledge_cancellations)
    subject.canceled_value.should eq 4.99
  end
end
