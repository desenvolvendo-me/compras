class ContractAdditiveDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :number, :additive_type, :signature_date
end
