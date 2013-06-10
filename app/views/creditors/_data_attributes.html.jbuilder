builder resource, json do
  json.id             resource.id
  json.email          resource.email
  json.person_email   resource.person_email
  json.login          resource.login
  json.modal_info_url modal_info_link(resource)

  json.proposals resource.purchase_process_creditor_proposals.where { licitation_process_id.eq( my{ params[:enabled_by_licitation] }) } do |proposal|
    json.purchase_process_creditor_proposal_id proposal.id
    json.code                                  proposal.material_code
    json.description                           proposal.material_description
    json.unit_price                            proposal.decorator.unit_price
    json.reference_unit                        proposal.material_reference_unit.to_s
    json.total_price                           proposal.decorator.total_price
    json.quantity                              proposal.item_quantity
  end

  json.realigment_prices resource.realigment_prices do |realigment_price|
    json.purchase_process_creditor_proposal_id realigment_price.id
    json.code                                  realigment_price.material_code
    json.description                           realigment_price.material_description
    json.unit_price                            realigment_price.decorator.price_with_precision
    json.reference_unit                        realigment_price.material_reference_unit.to_s
    json.total_price                           realigment_price.decorator.total_price
    json.quantity                              realigment_price.item.quantity
  end

  json.purchase_items resource.purchase_process_items do |item|
    json.code                                  item.code
    json.description                           item.description
    json.purchase_process_creditor_proposal_id nil
    json.purchase_process_item_id              item.id
    json.quantity                              item.quantity
    json.reference_unit                        item.reference_unit.to_s
    json.total_price                           item.decorator.estimated_total_price
    json.unit_price                            item.decorator.unit_price
  end

  json.ratification_items resource.licitation_process_ratification_items.where { compras_licitation_process_ratifications.licitation_process_id.eq(my{(params[:by_ratification_and_licitation_process_id])})} do |ratification_item|
    json.authorized_quantity  ratification_item.authorized_quantity
    json.balance              ratification_item.supply_order_item_balance
    json.material             ratification_item.material.to_s
    json.quantity             ratification_item.quantity
    json.ratification_item_id ratification_item.id
    json.reference_unit       ratification_item.reference_unit.to_s
    json.total_price          ratification_item.total_price
    json.unit_price           ratification_item.unit_price
  end
end
