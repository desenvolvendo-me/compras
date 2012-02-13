# encoding: utf-8
require 'model_helper'
require 'app/models/branch_classification'

describe BranchClassification do
  it 'return name when converted to string' do
    subject.name = 'Comércio'
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }

end
