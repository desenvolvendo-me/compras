LicitationProcess.blueprint(:processo_licitatorio) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.tomorrow) }
  envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
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
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2013, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
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
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.tomorrow) }
  envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante), LicitationProcessBidder.make!(:licitante_sobrinho)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
end

LicitationProcess.blueprint(:processo_licitatorio_publicacao_cancelada) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.tomorrow) }
  envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao_de_cancelamento)] }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
end

LicitationProcess.blueprint(:processo_licitatorio_canetas) do
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  process { 1 }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:compra_com_itens_3) }
  object_description { "Descricao das canetas" }
  pledge_type { PledgeType::ESTIMATED }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2013, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
end

LicitationProcess.blueprint(:apuracao_por_itens) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:apuracao_por_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:classificar_por_itens) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:classificacao_por_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:maior_lance_por_itens) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:maior_lance_por_itens) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_ITEM }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_por_lote) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:apuracao_por_lote) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:classificar_por_lote) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:classificacao_por_lote) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_LOT }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:maior_lance_por_lote) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:maior_lance_por_lote) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::HIGHEST_BIDDER_BY_LOT}
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_global) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:apuracao_global) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_melhor_tecnica_e_preco) do
  year { 2012 }
  process { 1 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  administrative_process { AdministrativeProcess.make!(:apuracao_melhor_tecnica_e_preco) }
  object_description { "Descricao" }
  pledge_type { PledgeType::GLOBAL }
  capability { Capability.make!(:reforma) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  envelope_opening_date { I18n.l(Date.current) }
  envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  legal_advice { LicitationProcessLegalAdvice::FAVORABLE }
  legal_advice_date { Date.new(2012, 3, 19) }
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  licitation_process_bidders { [LicitationProcessBidder.make!(:licitante_com_proposta_1),
                                LicitationProcessBidder.make!(:licitante_com_proposta_2)] }
end
