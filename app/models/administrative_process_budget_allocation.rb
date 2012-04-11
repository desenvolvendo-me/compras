class AdministrativeProcessBudgetAllocation < ActiveRecord::Base
  attr_accessible :administrative_process_id, :budget_allocation_id, :value

  belongs_to :administrative_process
  belongs_to :budget_allocation

  validates :budget_allocation, :value, :presence => true
end
