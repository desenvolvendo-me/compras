# encoding: utf-8
require 'model_helper'
require 'app/models/creditor'
require 'app/models/creditor_balance'

describe CreditorBalance do
  it { should belong_to :creditor }

  it { should validate_presence_of :fiscal_year }

  it { should allow_value('2012').for(:fiscal_year) }
  it { should_not allow_value('212').for(:fiscal_year) }
  it { should_not allow_value('2a12').for(:fiscal_year) }
end
