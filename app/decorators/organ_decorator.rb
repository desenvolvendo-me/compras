class OrganDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :code, :name, :initial,:category, :year

end
