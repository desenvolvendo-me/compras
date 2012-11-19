builder resource, json do
  json.id                   resource.id
  json.creditor_id          resource.creditor_id

  json.proposals resource.proposals do |json, proposal|
    json.id                 proposal.id
    json.code               proposal.code
    json.description        proposal.description
    json.unit_price         proposal.decorator.unit_price
    json.reference_unit     proposal.reference_unit.to_s
    json.total_price        proposal.decorator.total_price
    json.quantity           proposal.quantity
  end
end
