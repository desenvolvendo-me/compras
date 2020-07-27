class OccurrenceContractualHistoricDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :occurrence_contractual_historic_type, :occurrence_contractual_historic_change, :occurrence_date
end
