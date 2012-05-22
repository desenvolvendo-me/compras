require 'unit_helper'
require 'app/business/subpledge_expiration_movimentation_calculator'

describe SubpledgeExpirationMovimentationCalculator do
  subject do
    described_class.new(90, 100)
  end

  it 'should return expiration_value' do
    subject.expiration_value.should eq 10
  end

  context 'return movimented_value' do
    it 'when moviment value less than parcel_balance' do
      subject.movimented_value.should eq 90
    end

    it 'as parcel_balance when moviment_value greater parcel_balance' do
      subject.stub(:moviment_value).and_return(150)
      subject.movimented_value.should eq 100
    end

    it 'as parcel_balance when moviment_value equals to parcel_balance' do
      subject.stub(:moviment_value).and_return(100)
      subject.movimented_value.should eq 100
    end
  end
end
