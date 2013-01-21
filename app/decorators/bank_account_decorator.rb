class BankAccountDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :account_number, :bank, :agency, :status
end
