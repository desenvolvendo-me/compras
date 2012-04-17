class ReserveFundPresenter < Presenter::Proxy
  attr_modal :licitation_modality_id, :creditor_id, :status
  attr_modal :entity_id, :year, :budget_allocation_id, :reserve_allocation_type_id

  attr_data 'id' => :id, 'name' => :to_s, 'reserve-fund-value' => :value
  attr_data 'budget-allocation' => :budget_allocation
  attr_data 'budget-allocation-id' => :budget_allocation_id
  attr_data 'amount' => :budget_allocation_amount
  attr_data 'function' => :budget_allocation_function
  attr_data 'subfunction' => :budget_allocation_subfunction
  attr_data 'government_program' => :budget_allocation_government_program
  attr_data 'government_action=' => :budget_allocation_government_action
  attr_data 'budget-unit' => :budget_allocation_budget_unit
  attr_data 'expense-nature' => :budget_allocation_expense_nature
end
