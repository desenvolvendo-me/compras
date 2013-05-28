builder resource, json do
  json.email          resource.email
  json.person_email   resource.person_email
  json.login          resource.login
  json.modal_info_url modal_info_link(resource)
  json.id                   resource.id

  json.proposals resource.purchase_process_creditor_proposals do |proposal|
    json.purchase_process_creditor_proposal_id proposal.id
    json.code                                  proposal.material_code
    json.description                           proposal.material_description
    json.unit_price                            proposal.decorator.unit_price
    json.reference_unit                        proposal.material_reference_unit.to_s
    json.total_price                           proposal.decorator.total_price
    json.quantity                              proposal.item_quantity
  end

  json.purchase_items resource.purchase_process_items do |item|
    json.purchase_process_creditor_proposal_id nil
    json.purchase_process_item_id              item.id
    json.code                                  item.code
    json.description                           item.description
    json.unit_price                            item.decorator.unit_price
    json.reference_unit                        item.reference_unit.to_s
    json.total_price                           item.decorator.estimated_total_price
    json.quantity                              item.quantity
  end
end
