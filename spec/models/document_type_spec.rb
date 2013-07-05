# encoding: utf-8
require 'model_helper'
require 'app/models/document_type'
require 'app/models/bidder_document'
require 'app/models/licitation_process'

describe DocumentType do
  it 'should return description as to_s method' do
    subject.description = 'Fiscal'

    expect(subject.to_s).to eq 'Fiscal'
  end

  it { should validate_presence_of :validity }
  it { should validate_numericality_of :validity }
  it { should validate_presence_of :description }

  it { should have_many(:bidder_documents).dependent(:restrict) }
  it { should have_and_belong_to_many(:licitation_processes) }
end
