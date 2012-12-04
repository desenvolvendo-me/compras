class BankAccountDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :description, :status, :to_s => false, :link => :description
end
