builder resource, json do
  json.id             resource.id
  json.email          resource.email
  json.person_email   resource.person_email
  json.login          resource.login
  json.modal_info_url modal_info_link(resource)

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
