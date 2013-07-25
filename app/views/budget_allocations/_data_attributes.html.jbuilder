builder resource, json do
  json.to_s                          resource.to_s
  json.real_amount                   number_with_precision resource.real_amount
  json.amount                        resource.amount
  json.function                      resource.function.to_s
  json.subfunction                   resource.subfunction.to_s
  json.government_program            resource.government_program.to_s
  json.government_action             resource.government_action.to_s
  json.budget_structure              resource.budget_structure.to_s
  json.expense_nature                resource.expense_nature.to_s
  json.reserved_value                number_with_precision resource.reserved_value
  json.expense_nature_id             resource.expense_nature_id
  json.modal_info_url                modal_info_link(resource)
end
