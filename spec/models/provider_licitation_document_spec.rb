# encoding: utf-8
require 'model_helper'
require 'app/models/provider_licitation_document'
require 'app/models/provider'
require 'app/models/document_type'

describe ProviderLicitationDocument do
  it { should belong_to :provider }
  it { should belong_to :document_type }

  it { should validate_presence_of :document_type }
  it { should validate_presence_of :document_number }
  it { should validate_presence_of :emission_date }
  it { should validate_presence_of :expiration_date }

  it { should validate_numericality_of :document_number }
end
