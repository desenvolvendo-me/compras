# encoding: utf-8
require 'model_helper'
require 'app/models/regulatory_act_type_classification'
require 'app/models/regulatory_act_type'

describe RegulatoryActTypeClassification do
  it 'should return description as to_s method' do
    subject.description = 'Classification of Types'
    subject.to_s.should eq 'Classification of Types'
  end

  it { should validate_presence_of(:description) }

  it { should have_many(:regulatory_act_types).dependent(:restrict) }
end
