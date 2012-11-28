builder resource, json do
  json.purchase_solicitation  resource.to_s
  json.quantity_by_material   resource.decorator.quantity_by_material(params[:by_material_id])

  json.total            resource.total_allocations_items_value.to_f
  json.modal_info_url   purchase_solicitation_path(resource, :format => :js)

  json.budget_structure resource.budget_structure, :id, :to_s if resource.budget_structure

  json.budget_allocations resource.purchase_solicitation_budget_allocations do |json, budget_allocation|
    json.id                   budget_allocation.id
    json.description          budget_allocation.budget_allocation.to_s
    json.budget_allocation_id budget_allocation.budget_allocation_id
    json.expense_nature       budget_allocation.budget_allocation.expense_nature.to_s
    json.amount               budget_allocation.budget_allocation.amount.to_f

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
