# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_bank_account'

describe AgreementBankAccount do
  it { should validate_presence_of :bank_account }
  it { should validate_presence_of :creation_date }
  it { should validate_presence_of :status }

  it { should belong_to(:agreement) }
  it { should belong_to(:bank_account) }
end
