# encoding: utf-8
require 'model_helper'
require 'app/models/pledge_parcel'
require 'app/models/pledge_parcel_movimentation'

describe PledgeParcel do
  it { should belong_to :pledge }

  it { should have_many(:pledge_parcel_movimentations).dependent(:restrict) }

  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :value }

  it 'should return correct balance value' do
    subject.value = 10
    subject.stub(:canceled_value).and_return(2)
    subject.stub(:liquidations_value).and_return(3)
    subject.stub(:canceled_liquidations_value).and_return(3)
    subject.balance.should eq 8
  end

  it 'should return correct cancellation_moviments value' do
    subject.stub(:canceled_value).and_return(2)
    subject.stub(:liquidations_value).and_return(3)
    subject.cancellation_moviments.should eq 5
  end
end
