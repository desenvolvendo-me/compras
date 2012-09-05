# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_additive'

describe AgreementAdditive do
  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :value }

  it { should belong_to(:agreement) }
  it { should belong_to(:regulatory_act) }
end
