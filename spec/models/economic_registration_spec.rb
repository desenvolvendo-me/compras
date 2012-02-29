require 'model_helper'
require 'app/models/economic_registration'

describe EconomicRegistration do
  it 'should return registration as to_s' do
    subject.registration = '452.624.634.819'
    subject.to_s.should eq '452.624.634.819'
  end

  it { should belong_to :person }
end
