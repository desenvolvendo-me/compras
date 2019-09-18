class PurchaseFormDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name,:budget_allocation
end
