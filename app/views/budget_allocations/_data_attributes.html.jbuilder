builder resource, json do
  json.real_amount        resource.decorator.real_amount
  json.amount             resource.amount
  json.function           resource.function.to_s
  json.subfunction        resource.subfunction.to_s
  json.government_program resource.government_program.to_s
  json.government_action  resource.government_action.to_s
  json.budget_unit        resource.budget_unit.to_s
  json.expense_nature     resource.expense_nature.to_s
  json.reserved_value     resource.reserved_value
  json.modal_info_url     "/budget_allocations/#{resource.id}.js"
end
