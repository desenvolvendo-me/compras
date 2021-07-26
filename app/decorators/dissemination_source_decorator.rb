class DisseminationSourceDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :communication_source
end
