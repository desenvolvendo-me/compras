# encoding: utf-8
require 'model_helper'
require 'app/models/administractive_act_type_classification'
require 'app/models/type_of_administractive_act'

describe AdministractiveActTypeClassification do
  it 'should return description as to_s method' do
    subject.description = 'Classification of Types'
    subject.to_s.should eq 'Classification of Types'
  end

  it { should validate_presence_of(:description) }

  it { should have_many(:type_of_administractive_acts).dependent(:restrict) }
end
