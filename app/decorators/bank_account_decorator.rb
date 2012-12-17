class BankAccountDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :account_number, :bank, :agency, :status, :to_s => false, :link => :account_number
end
