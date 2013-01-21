class AgencyDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :bank
end
