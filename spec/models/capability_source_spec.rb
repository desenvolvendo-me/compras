require 'model_helper'
require 'app/models/capability_source'
require 'app/models/tce_specification_capability'
require 'app/models/structure_account_information'

describe CapabilitySource do
  it 'should return name as to_s' do
    subject.name = 'Imposto'
    subject.to_s.should eq 'Imposto'
  end

  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  it { should validate_presence_of :specification }
  it { should validate_presence_of :source }

  it { should have_many :tce_specification_capabilities }
  it { should have_many :structure_account_informations }
end
