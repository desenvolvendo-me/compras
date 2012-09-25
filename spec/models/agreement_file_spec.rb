# encoding: utf-8
require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/agreement_file'

describe AgreementFile do
  it { should validate_presence_of :name }
  it { should validate_presence_of :file }

  it { should belong_to(:agreement) }
end
