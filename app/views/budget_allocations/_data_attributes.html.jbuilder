builder resource, json do
  json.real_amount         resource.decorator.real_amount
  json.amount              resource.amount
  json.function            resource.function.to_s
  json.subfunction         resource.subfunction.to_s
  json.government_program  resource.government_program.to_s
  json.government_action   resource.government_action.to_s
  json.budget_structure    resource.budget_structure.to_s
  json.expense_nature      resource.expense_nature.to_s
  json.reserved_value      resource.decorator.reserved_value
  json.expense_category_id resource.expense_category_id
  json.expense_group_id    resource.expense_group_id
  json.expense_modality_id resource.expense_modality_id
  json.expense_element_id  resource.expense_element_id
  json.modal_info_url      budget_allocation_path(resource, :format => :js)
end
