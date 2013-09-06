json.array!(collection) do |obj|
  json.id                        obj.id
  json.value                     obj.to_s
  json.label                     obj.to_s
  json.material                  obj.material.to_s
  json.material_id               obj.material.id
  json.balance                   obj.supply_order_item_balance
  json.value_balance             number_with_precision obj.supply_order_item_value_balance
  json.reference_unit            obj.reference_unit.to_s
  json.total_price               number_with_precision obj.estimated_total_price
  json.unit_price                number_with_precision obj.unit_price
  json.authorized_value          number_with_precision obj.authorized_value
  json.authorized_quantity       obj.authorized_quantity
  json.service_without_quantity  obj.service_without_quantity?
  json.quantity                  obj.quantity
end
