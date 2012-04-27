LicitationProcess.blueprint(:processo_licitatorio) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
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
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
end

LicitationProcess.blueprint(:processo_licitatorio_computador) do
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  process { 1 }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens_2) }
  object_description { "Descricao do computador" }
  pledge_type { PledgeType::ESTIMATED }
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
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2013, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_invited_bidders { [LicitationProcessInvitedBidder.make!(:licitante)] }
end

LicitationProcess.blueprint(:processo_licitatorio_fornecedores) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
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
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_invited_bidders { [LicitationProcessInvitedBidder.make!(:licitante), LicitationProcessInvitedBidder.make!(:licitante_sobrinho)] }
end

