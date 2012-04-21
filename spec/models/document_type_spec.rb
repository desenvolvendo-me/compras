# encoding: utf-8
require 'model_helper'
require 'app/models/document_type'
require 'app/models/provider_licitation_document'
require 'app/models/licitation_process_invited_bidder_document'
require 'app/models/licitation_process'

describe DocumentType do
  it 'should return description as to_s method' do
    subject.description = 'Fiscal'

    subject.to_s.should eq 'Fiscal'
  end

  it { should validate_presence_of :validity }
  it { should validate_numericality_of :validity }
  it { should validate_presence_of :description }

  it { should have_many(:provider_licitation_documents).dependent(:restrict) }
  it { should have_many(:licitation_process_invited_bidder_documents).dependent(:restrict) }
  it { should have_and_belong_to_many(:licitation_processes) }
end
