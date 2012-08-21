require 'model_helper'
require 'app/models/capability_source'

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
end