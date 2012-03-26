LicitationProcess.blueprint(:processo_licitatorio) do
  year { 2012 }
  process_date { "2012-03-19" }
  administrative_process { AdministrativeProcess.make!(:compra_de_cadeiras) }
  object_description { "Descricao" }
  capability { Capability.make!(:reforma) }
  expiration { "10 dias" }
  readjustment_index { "XPTO" }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.tomorrow) }
  envelope_opening_time { "14:00" }
  period { Period.make!(:um_ano) }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { "2012-03-19" }
  contract_date { "2012-03-19" }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_budget_allocations { [LicitationProcessBudgetAllocation.make!(:alocacao)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_invited_bidders { [LicitationProcessInvitedBidder.make!(:licitante)] }
end
