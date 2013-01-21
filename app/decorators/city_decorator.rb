class CityDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :state, :code
end
