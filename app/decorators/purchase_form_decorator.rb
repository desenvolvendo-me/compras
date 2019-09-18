class PurchaseFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :number,:budget_allocation
end
