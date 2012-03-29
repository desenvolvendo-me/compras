require 'model_helper'
require 'app/models/regulatory_act_type'
require 'app/models/regulatory_act'

describe RegulatoryActType do
  it 'should return description as to_s method' do
    subject.description = 'Lei'
    subject.to_s.should eq 'Lei'
  end

  it { should have_many(:regulatory_acts).dependent(:restrict) }
  it { should belong_to :regulatory_act_type_classification }

  it { should validate_presence_of :description }
  it { should validate_presence_of :regulatory_act_type_classification }
end
