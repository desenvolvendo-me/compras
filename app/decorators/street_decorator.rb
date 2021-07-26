class StreetDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :street_type, :city
end
