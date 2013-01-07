builder resource, json do
  json.id               resource.id
  json.total            resource.total_purchase_solicitation_budget_allocations_sum.to_f
  json.modal_info_url   purchase_solicitation_item_group_path(resource, :format => :js)

  json.purchase_solicitations resource.purchase_solicitations do |json, purchase_solicitation|
    json.id purchase_solicitation.id

    json.budget_allocations purchase_solicitation.purchase_solicitation_budget_allocations_by_material(resource.material_ids) do |json, ps_budget_allocation|
      json.id                   ps_budget_allocation.id
      json.description          ps_budget_allocation.budget_allocation.to_s
      json.budget_allocation_id ps_budget_allocation.budget_allocation_id
      json.expense_nature       ps_budget_allocation.budget_allocation.expense_nature.to_s
      json.amount               ps_budget_allocation.budget_allocation.amount.to_f
      json.total_items_value    ps_budget_allocation.total_items_value.to_f

      json.items ps_budget_allocation.items_by_material(resource.material_ids) do |json, item|
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
end
