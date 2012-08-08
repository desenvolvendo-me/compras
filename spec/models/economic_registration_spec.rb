require 'model_helper'
require 'app/models/economic_registration'

describe EconomicRegistration do
  describe 'default values' do
    it 'uses false as default for location_operation_fee' do
      expect(subject.location_operation_fee).to be false
    end

    it 'uses false as default for special_schedule_fee' do
      expect(subject.special_schedule_fee).to be false
    end

    it 'uses false as default for publicity_fee' do
      expect(subject.publicity_fee).to be false
    end

    it 'uses false as default for sanitary_permit_fee' do
      expect(subject.sanitary_permit_fee).to be false
    end

    it 'uses false as default for land_use_fee' do
      expect(subject.land_use_fee).to be false
    end

    it 'uses true as default for active' do
      expect(subject.active).to be true
    end
  end

  it 'should return registration as to_s' do
    subject.registration = '452.624.634.819'
    expect(subject.to_s).to eq '452.624.634.819'
  end

  it { should belong_to :person }
end
