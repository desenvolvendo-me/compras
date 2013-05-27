builder resource, json do
  json.email          resource.email
  json.person_email   resource.person_email
  json.login          resource.login
  json.modal_info_url modal_info_link(resource)
  json.id                   resource.id

  json.proposals resource.purchase_process_creditor_proposals do |json, proposal|
    json.id                 proposal.id
    json.code               proposal.material_code
    json.description        proposal.material_description
    json.unit_price         proposal.decorator.unit_price
    json.reference_unit     proposal.material_reference_unit.to_s
    json.total_price        proposal.decorator.total_price
    json.quantity           proposal.item_quantity
  end
end
