# encoding: utf-8
require 'model_helper'
require 'app/models/creditor'
require 'app/models/creditor_balance'

describe CreditorBalance do
  it { should belong_to :creditor }

  it { should validate_presence_of :fiscal_year }
end
