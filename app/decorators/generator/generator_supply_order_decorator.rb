class Generator::GeneratorSupplyOrderDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :control_code, :user, :status
end
