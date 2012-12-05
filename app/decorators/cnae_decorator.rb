class CnaeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :code, :risk_degree, :to_s => false, :link => :name
end
