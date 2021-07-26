class DistrictDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :city
end
