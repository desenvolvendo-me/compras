class RiskDegreeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :level, :to_s => false, :link => :name
end
