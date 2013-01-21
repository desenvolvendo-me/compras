class DeliveryLocationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :street, :number
end
