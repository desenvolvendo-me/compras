json.array! @winners do |trading_item|
  json.trading_item_id           trading_item.id
  json.purchase_process_item_id  trading_item.item.id
  json.code                      trading_item.item.code
  json.description               trading_item.item.description
  json.quantity                  trading_item.item.quantity
  json.unit_price                trading_item.decorator.lowest_proposal_amount
  json.reference_unit            trading_item.item.reference_unit.to_s
  json.total_price               trading_item.decorator.total_price
end
