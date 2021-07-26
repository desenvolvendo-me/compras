json.array!(collection) do |obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.code_and_year     obj.decorator.code_and_year
  json.department        obj.department.to_s
  json.user              obj.user.to_s
  json.total_items_value obj.total_items_value.to_f

  json.budget_allocations obj.purchase_solicitation_budget_allocations do |psba|
    json.id                                  psba.id
    json.to_s                                psba.to_s
    json.budget_allocation                   psba.budget_allocation.to_s
    json.budget_allocation_id                psba.budget_allocation_id
    json.budget_allocation_expense_nature    psba.budget_allocation_expense_nature.to_s
    json.budget_allocation_expense_nature_id psba.budget_allocation_expense_nature.try(:id)
    json.expense_nature                      psba.expense_nature.to_s
    json.expense_nature_id                   psba.expense_nature_id.to_s
    json.balance                             number_with_precision psba.budget_allocation_balance
    json.estimated_value                     psba.estimated_value.to_f
  end

  json.items obj.items do |item|
    json.id                           item.id
    json.material_id                  item.material_id
    json.material_description         item.material.to_s
    json.lot                          item.lot
    json.brand                        item.brand
    json.reference_unit               item.material&.reference_unit&.acronym
    json.quantity                     item.quantity.to_f
    json.unit_price                   item.unit_price.to_f
    json.estimated_total_price        item.estimated_total_price.to_f
    json.average_proposal_unit_price  item.average_proposal_item_price.to_f
    json.average_proposal_total_price item.average_proposal_total_price.to_f
    json.proposal_winner              item.proposal_creditor_winner.try(:to_s)
    json.proposal_winner_id           item.proposal_creditor_winner.try(:id)
    json.proposal_unit_price_winner   item.proposal_unit_price_winner.to_f
    json.proposal_total_price_winner  item.proposal_total_price_winner.to_f
  end

end
