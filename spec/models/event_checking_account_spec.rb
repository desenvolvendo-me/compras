# encoding: utf-8
require 'model_helper'
require 'app/models/event_checking_account'

describe EventCheckingAccount do
  it { should validate_presence_of :checking_account_of_fiscal_account }
  it { should validate_presence_of :nature_release }
  it { should validate_presence_of :operation }

  it { should belong_to(:checking_account_of_fiscal_account) }
end
