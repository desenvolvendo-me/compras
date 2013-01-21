class LandSubdivisionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name
end
