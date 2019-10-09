class ListPurchaseSolicitationDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :balance, :consumed_value, :expected_value,
              :resource_source,:licitation_process_id,
              :purchase_solicitation_id

end
