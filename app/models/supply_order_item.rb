class SupplyOrderItem < Compras::Model
  attr_accessible :authorization_quantity, :licitation_process_ratification_item_id,
    :supply_order_id

  belongs_to :supply_order
  belongs_to :licitation_process_ratification_item

  delegate  :material, :reference_unit, :unit_price, :quantity, :total_price,
    to: :licitation_process_ratification_item

  orderize "id DESC"
  filterize
end
