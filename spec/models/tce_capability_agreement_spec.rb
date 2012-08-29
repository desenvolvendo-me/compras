# encoding: utf-8
require 'model_helper'
require 'app/models/tce_capability_agreement'

describe TceCapabilityAgreement do
  it { should validate_presence_of :tce_specification_capability }
  it { should validate_presence_of :agreement }

  it { should belong_to :tce_specification_capability }
  it { should belong_to :agreement }
end
