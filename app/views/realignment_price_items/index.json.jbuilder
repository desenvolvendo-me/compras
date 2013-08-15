json.array! collection do |realigment_price|
  json.id                       realigment_price.id
  json.purchase_process_item_id realigment_price.purchase_process_item_id
  json.code                     realigment_price.material_code
  json.description              realigment_price.material_description
  json.reference_unit           realigment_price.material_reference_unit.to_s
  json.unit_price               number_with_precision(realigment_price.price)
  json.total_price              number_with_precision(realigment_price.total_price)
  json.quantity                 realigment_price.item.quantity
end
