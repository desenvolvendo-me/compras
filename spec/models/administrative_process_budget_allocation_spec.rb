# encoding: utf-8
require 'model_helper'
require 'app/models/administrative_process_budget_allocation'
require 'app/models/material'

describe AdministrativeProcessBudgetAllocation do
  it { should belong_to :licitation_process }
  it { should belong_to :budget_allocation }

  it { should validate_presence_of :budget_allocation }
  it { should validate_presence_of :value }

  it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:amount).to(:budget_allocation).allowing_nil(true).prefix(true) }

  it { should delegate(:type_of_calculation).to(:licitation_process).allowing_nil(true) }
end
