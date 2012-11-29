class EmployeeDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :person, :position, :registration
end
