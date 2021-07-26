class SupplyOrderRequests < Compras::Model
  attr_accessible :supply_order_id, :supply_request_id

  belongs_to :supply_order
  belongs_to :supply_request
end
