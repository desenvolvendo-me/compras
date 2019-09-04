class DepartmentPersonDecorator
  include Decore::Header
  include Decore::Proxy
  include Decore::Header
  
  attr_header :person
end
