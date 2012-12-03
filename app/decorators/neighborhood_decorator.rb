class NeighborhoodDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :city, :to_s => false, :link => :name
end
