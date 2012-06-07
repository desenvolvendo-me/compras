# encoding: utf-8
require 'model_helper'
require 'app/models/creditor_bank_account'

describe CreditorBankAccount do
  it { should belong_to :creditor }
  it { should belong_to :agency }

  it { should validate_presence_of :creditor }
  it { should validate_presence_of :agency }
  it { should validate_presence_of :status }
  it { should validate_presence_of :account_type }
  it { should validate_presence_of :digit }
  it { should validate_presence_of :number }

  it { should have_db_index([:agency_id, :number]).unique(true) }
end
