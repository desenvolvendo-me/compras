class PurchaseProcessBudgetAllocation < Compras::Model
  attr_accessible :value, :budget_allocation, :expense_nature_id,
                  :licitation_process_id, :budget_allocation_id, :split_expense

  belongs_to :licitation_process
  belongs_to :budget_allocation
  belongs_to :expense_nature
  belongs_to :split_expense

end
