json.array!(collection) do |json, obj|
  json.id               obj.id
  json.value            obj.to_s
  json.label            obj.to_s
  json.code_and_year    obj.code_and_year
  json.budget_structure obj.budget_structure.to_s
  json.responsible      obj.responsible.to_s

  json.budget_allocations obj.purchase_solicitation_budget_allocations do |json, budget_allocation|
    json.id                   budget_allocation.id
    json.to_s                 budget_allocation.to_s
    json.budget_allocation_id budget_allocation.budget_allocation_id
    json.expense_nature       budget_allocation.budget_allocation.expense_nature.to_s
    json.amount               budget_allocation.budget_allocation.amount.to_f
    json.total_items_value    budget_allocation.total_items_value.to_f

    json.items budget_allocation.items do |json, item|
      json.id                    item.id
      json.order                 item.order
      json.material_id           item.material_id
      json.material_description  item.material.to_s
      json.brand                 item.brand
      json.reference_unit        item.reference_unit.acronym
      json.quantity              item.quantity.to_f
      json.unit_price            item.unit_price.to_f
      json.estimated_total_price item.estimated_total_price.to_f
      json.status                item.status
    end
  end
end
