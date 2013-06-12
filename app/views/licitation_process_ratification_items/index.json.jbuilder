json.array! collection do |ratification_item|
    json.id                   ratification_item.id
    json.authorized_quantity  ratification_item.authorized_quantity
    json.balance              ratification_item.supply_order_item_balance
    json.material             ratification_item.material.to_s
    json.quantity             ratification_item.quantity
    json.reference_unit       ratification_item.reference_unit.to_s
    json.total_price          ratification_item.total_price
    json.unit_price           ratification_item.unit_price
end
