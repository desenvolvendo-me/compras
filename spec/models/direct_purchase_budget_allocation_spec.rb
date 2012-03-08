# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase_budget_allocation'
require 'app/models/direct_purchase'
require 'app/models/budget_allocation'

describe DirectPurchaseBudgetAllocation do
  it { should belong_to :direct_purchase }
  it { should belong_to :budget_allocation }

  it { should have_many(:items).dependent(:destroy) }
end
