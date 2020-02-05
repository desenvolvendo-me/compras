class GeneratorSupplyOrderRequests < Compras::Model
  attr_accessible :generator_supply_order_id, :supply_request_id

  belongs_to :generator_supply_order
  belongs_to :supply_request
end
