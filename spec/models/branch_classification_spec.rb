# encoding: utf-8
require 'model_helper'
require 'app/models/branch_classification'
require 'app/models/branch_activity'

describe BranchClassification do
  it 'return name when converted to string' do
    subject.name = 'Comércio'
    subject.name.should eq subject.to_s
  end

  it { should have_many :branch_activities }

  it { should validate_presence_of :name }

end
