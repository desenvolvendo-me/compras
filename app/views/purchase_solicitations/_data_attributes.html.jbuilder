builder resource, json do
  json.purchase_solicitation resource.to_s
  json.quantity_by_material resource.decorator.quantity_by_material(params[:by_material_id])
  json.total resource.total_items_value.to_f
  json.modal_info_url modal_info_link(resource)
  json.kind resource.kind
  json.budget_structure resource.budget_structure, :id, :to_s if resource.budget_structure
  json.responsible resource.responsible, :id, :to_s if resource.responsible
  json.delivery_location resource.delivery_location, :id, :to_s if resource.delivery_location

  json.budget_allocations resource.purchase_solicitation_budget_allocations do |budget_allocation|
    json.id budget_allocation.id
    json.to_s budget_allocation.to_s
    json.budget_allocation_id budget_allocation.budget_allocation_id
    json.expense_nature budget_allocation.budget_allocation_expense_nature.to_s
    json.balance budget_allocation.budget_allocation.balance.to_f
  end

  json.items resource.items do |item|
    json.id item.id
    json.material_id item.material_id
    json.material_description item.material.to_s
    json.lot item.lot
    json.brand item.brand
    json.reference_unit item.reference_unit.acronym if item.reference_unit
    json.quantity item.quantity.to_f
    json.unit_price item.unit_price.to_f
    json.estimated_total_price item.estimated_total_price.to_f
  end

  json.purchase_forms resource.purchase_forms do |purchase_form|
    json.id purchase_form.id
    json.purchase_form_id purchase_form.purchase_form.id
    json.purchase_form_description purchase_form.purchase_form.to_s
  end


end
