class DepartmentPersonDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :department,:user

end
