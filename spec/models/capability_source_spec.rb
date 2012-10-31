require 'model_helper'
require 'app/models/capability_source'
require 'app/models/checking_account_structure_information'

describe CapabilitySource do
  it 'should return name as to_s' do
    subject.name = 'Imposto'
    subject.to_s.should eq 'Imposto'
  end
end
