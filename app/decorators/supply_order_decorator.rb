class SupplyOrderDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :creditor, :authorization_date, :licitation_process
end
