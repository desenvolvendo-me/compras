class DepartmentDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description,:purchasing_unit

end
