require 'model_helper'
require 'app/models/economic_registration'

describe EconomicRegistration do
  describe 'default values' do
    it 'uses false as default for location_operation_fee' do
      subject.location_operation_fee.should be false
    end

    it 'uses false as default for special_schedule_fee' do
      subject.special_schedule_fee.should be false
    end

    it 'uses false as default for publicity_fee' do
      subject.publicity_fee.should be false
    end

    it 'uses false as default for sanitary_permit_fee' do
      subject.sanitary_permit_fee.should be false
    end

    it 'uses false as default for land_use_fee' do
      subject.land_use_fee.should be false
    end

    it 'uses true as default for active' do
      subject.active.should be true
    end
  end

  it 'should return registration as to_s' do
    subject.registration = '452.624.634.819'
    subject.to_s.should eq '452.624.634.819'
  end

  it { should belong_to :person }
end
