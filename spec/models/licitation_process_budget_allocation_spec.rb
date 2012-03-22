# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_budget_allocation'
require 'app/models/licitation_process'
require 'app/models/budget_allocation'

describe LicitationProcessBudgetAllocation do
  it { should belong_to :licitation_process }
  it { should belong_to :budget_allocation }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :estimated_value }
  it { should validate_presence_of :pledge_type }
end
