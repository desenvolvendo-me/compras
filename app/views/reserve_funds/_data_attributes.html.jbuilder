builder resource, json do
  json.reserve_fund_value   resource.value
  json.budget_allocation    resource.budget_allocation.to_s
  json.budget_allocation_id resource.budget_allocation_id
  json.function             resource.budget_allocation_function.to_s
  json.subfunction          resource.budget_allocation_subfunction.to_s
  json.government_program   resource.budget_allocation_government_program.to_s
  json.government_action    resource.budget_allocation_government_action.to_s
  json.budget_structure     resource.budget_allocation_budget_structure.to_s
  json.expense_nature       resource.budget_allocation_expense_nature.to_s
  json.amount               resource.decorator.budget_allocation_amount
end
