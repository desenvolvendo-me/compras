class CustomizationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :state, :model
end
