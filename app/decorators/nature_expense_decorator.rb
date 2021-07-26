class NatureExpenseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :nature
end
