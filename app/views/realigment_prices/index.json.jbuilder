json.array! collection do |realigment_price|
  json.id             realigment_price.id
  json.code           realigment_price.material_code
  json.description    realigment_price.material_description
  json.unit_price     realigment_price.decorator.price_with_precision
  json.reference_unit realigment_price.material_reference_unit.to_s
  json.total_price    realigment_price.decorator.total_price
  json.quantity       realigment_price.item.quantity
end
