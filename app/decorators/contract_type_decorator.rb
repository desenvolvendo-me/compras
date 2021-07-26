class ContractTypeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description
end
