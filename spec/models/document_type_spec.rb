# encoding: utf-8
require 'model_helper'
require 'app/models/document_type'

describe DocumentType do
  it 'should return description as to_s method' do
    subject.description = 'Fiscal'

    subject.to_s.should eq 'Fiscal'
  end

  it { should validate_presence_of :validity }
  it { should validate_numericality_of :validity }
  it { should validate_presence_of :description }
end
