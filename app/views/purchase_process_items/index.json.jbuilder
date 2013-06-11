json.array! collection do |item|
  json.id                       item.id
  json.code                     item.code
  json.description              item.description
  json.purchase_process_item_id item.id
  json.quantity                 item.quantity
  json.reference_unit           item.reference_unit.to_s
  json.total_price              item.decorator.estimated_total_price
  json.unit_price               item.decorator.unit_price
end
