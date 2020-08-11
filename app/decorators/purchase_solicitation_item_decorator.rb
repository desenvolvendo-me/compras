class PurchaseSolicitationItemDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :material, :lot, :reference_unit, :brand, :quantity, :unit_price, :estimated_total_price

end
