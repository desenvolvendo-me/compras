# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_participant'

describe AgreementParticipant do
  it { should validate_presence_of :kind }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :value }
  it { should validate_presence_of :governmental_sphere }

  it { should belong_to(:agreement) }
  it { should belong_to(:creditor) }
end
