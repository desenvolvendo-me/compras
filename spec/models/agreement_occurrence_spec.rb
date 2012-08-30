# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_occurrence'

describe AgreementOccurrence do
  it { should validate_presence_of :kind }
  it { should validate_presence_of :date }
  it { should validate_presence_of :description }

  it { should belong_to(:agreement) }
end
