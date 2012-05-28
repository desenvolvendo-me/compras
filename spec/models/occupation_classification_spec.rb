# encoding: utf-8
require 'model_helper'
require 'app/models/occupation_classification'
require 'app/models/creditor'

describe OccupationClassification do
  it "return code and description when call to_s" do
    subject.code = '010315'
    subject.name = 'Praça da marinha'
    subject.to_s.should eq "#{subject.code} - #{subject.name}"
  end

  it { should have_many(:creditors).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
end
