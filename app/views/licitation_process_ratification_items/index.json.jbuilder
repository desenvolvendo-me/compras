json.array! collection do |ratification_item|
    json.id                   ratification_item.id
    json.authorized_quantity  ratification_item.authorized_quantity
    json.authorized_value     ratification_item.decorator.authorized_value
    json.balance              ratification_item.supply_order_item_balance
    json.value_balance        ratification_item.decorator.supply_order_item_value_balance
    json.material             ratification_item.material.to_s
    json.quantity             ratification_item.quantity
    json.reference_unit       ratification_item.reference_unit.to_s
    json.total_price          ratification_item.decorator.total_price
    json.unit_price           ratification_item.decorator.unit_price
    json.control_amount       ratification_item.control_amount?
end
