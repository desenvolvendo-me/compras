# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice_member'

describe JudgmentCommissionAdviceMember do
  it { should belong_to :judgment_commission_advice }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }
end
