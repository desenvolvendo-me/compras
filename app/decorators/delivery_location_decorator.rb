class DeliveryLocationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :street, :number, :to_s => false, :link => :description
end
