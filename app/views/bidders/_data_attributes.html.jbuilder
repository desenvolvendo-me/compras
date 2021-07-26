builder resource, json do
  json.id                   resource.id
  json.creditor_id          resource.creditor_id
  json.id                   resource.decorator.by_licitation_process

  json.proposals resource.creditor_proposals do |proposal|
    json.id                 proposal.id
    json.code               proposal.material_code
    json.description        proposal.material_description
    json.unit_price         proposal.decorator.unit_price
    json.reference_unit     proposal.material_reference_unit.to_s
    json.total_price        proposal.decorator.total_price
    json.quantity           proposal.item_quantity
  end
end
