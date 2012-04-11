# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation'

describe AdministrativeProcessBudgetAllocation do
  it { should belong_to :administrative_process }
  it { should belong_to :budget_allocation }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }
end
