class StageProcessDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :type_of_purchase
end
