class GeneratorSupplyOrderRequest < Compras::Model
  attr_accessible :generator_supply_order_id, :supply_request_id

  belongs_to :generator_supply_order
  belongs_to :supply_request


  def to_s
    self.supply_request.to_s
  end
end
