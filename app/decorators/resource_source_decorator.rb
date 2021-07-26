class ResourceSourceDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :code, :year, :number_convention
end
