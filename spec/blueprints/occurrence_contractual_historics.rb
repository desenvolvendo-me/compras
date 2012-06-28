# encoding: utf-8
OccurrenceContractualHistoric.blueprint(:example) do
  contract { Contract.make!(:primeiro_contrato) }
  occurrence_contractual_historic_type { OccurrenceContractualHistoricType::OTHERS }
  occurrence_contractual_historic_change { OccurrenceContractualHistoricChange::BILATERAL }
  occurrence_date { Date.new(2012, 7, 1) }
  observations { "divergência contractual" }
  sequence { 1 }
end
