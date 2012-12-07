class PaymentMethodDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :to_s => false, :link => :description
end
