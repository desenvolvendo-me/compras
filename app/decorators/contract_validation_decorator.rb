class ContractValidationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :blocked, :date, :responsible
end
