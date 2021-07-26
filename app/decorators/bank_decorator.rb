class BankDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :code, :acronym
end
