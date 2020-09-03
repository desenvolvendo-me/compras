class LinkedContractDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :contract_number,:start_date_contract,:end_date_contract,:contract_value
end
