builder resource, json do
  json.budget_structure     resource.budget_structure.to_s
  json.modality             resource.modality
  json.modality_humanize    resource.modality_humanize
  json.item                 resource.item
  json.object_type_humanize resource.object_type_humanize
  json.judgment_form        resource.judgment_form.to_s
  json.description          resource.description
  json.responsible          resource.responsible.to_s
  json.judgment_form_kind   resource.judgment_form_kind
  json.object_type          resource.object_type

  json.budget_allocations resource.administrative_process_budget_allocations do |json, budget_allocation|
    json.id                    budget_allocation.id
    json.description           budget_allocation.budget_allocation.to_s
    json.budget_allocation_id  budget_allocation.budget_allocation_id
    json.value                 budget_allocation.value.to_f
    json.expense_nature        budget_allocation.budget_allocation_expense_nature.to_s
    json.amount                budget_allocation.budget_allocation_amount.to_f
  end
end
