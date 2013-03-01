# encoding: utf-8
LicitationProcess.blueprint(:processo_licitatorio) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  responsible { Employee.make!(:sobrinho) }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  price_registration { true }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  disqualify_by_documentation_problem { true }
  disqualify_by_maximum_value { true }
  consider_law_of_proposals { false }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_computador) do
  process { 2 }
  protocol { '00089/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  licitation_number { 1 }
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
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  bidders { [Bidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_fornecedores) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
  pledge_type { PledgeType::GLOBAL }
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
  contract_date { Date.new(2012, 3, 19) }
  contract_expiration { 3 }
  observations { "observacoes" }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  bidders { [Bidder.make!(:licitante), Bidder.make!(:licitante_sobrinho)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_publicacao_cancelada) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  responsible { Employee.make!(:sobrinho) }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_canetas) do
  process { 2 }
  protocol { '00089/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  licitation_number { 1 }
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
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  bidders { [Bidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:apuracao_por_itens) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  disqualify_by_documentation_problem { false }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_por_lote) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_lote_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:valor_maximo_ultrapassado) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_lote_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_PRICE_BY_LOT }
  bidders { [Bidder.make!(:licitante_com_proposta_3),
             Bidder.make!(:licitante_com_proposta_7)] }
end

LicitationProcess.blueprint(:maior_lance_por_lote) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::CALL_NOTICE }
  modality { Modality::CONCURRENCE }
  judgment_form { JudgmentForm.make!(:por_lote_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_global) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:apuracao_global_empatou) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_5),
             Bidder.make!(:licitante_com_proposta_6)] }
end

LicitationProcess.blueprint(:apuracao_global_sem_documentos) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_3, :documents => []),
             Bidder.make!(:licitante_com_proposta_4, :documents => [])] }
end

LicitationProcess.blueprint(:apuracao_global_small_company) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_3),
             Bidder.make!(:licitante_com_proposta_4)] }
end

LicitationProcess.blueprint(:apuracao_global_small_company_without_new_proposal) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_3, :will_submit_new_proposal_when_draw => false),
             Bidder.make!(:licitante_com_proposta_4)] }
end

LicitationProcess.blueprint(:apuracao_global_small_company_2) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_8),
             Bidder.make!(:licitante_com_proposta_9)] }
end

LicitationProcess.blueprint(:processo_licitatorio_nao_atualizavel) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao_nao_atualizavel)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_canetas_sem_lote) do
  process { 2 }
  protocol { '00089/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  licitation_number { 1 }
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
  bidders { [Bidder.make!(:licitante)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:apuracao_melhor_tecnica_e_preco) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
end

LicitationProcess.blueprint(:pregao_presencial) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::TRADING }
  judgment_form { JudgmentForm.make!(:por_item_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  summarized_object { "Descrição resumida do objeto" }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  consider_law_of_proposals { true }
  document_types { [DocumentType.make!(:fiscal)] }
  execution_type { ExecutionType::INTEGRAL }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  type_of_calculation { LicitationProcessTypeOfCalculation::SORT_PARTICIPANTS_BY_ITEM }
  bidders { [Bidder.make!(:licitante_sobrinho), Bidder.make!(:licitante), Bidder.make!(:me_pregao)] }
end

LicitationProcess.blueprint(:processo_licitatorio_concurso) do
  process { 1 }
  protocol { '00099/2012' }
  object_type { AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES }
  modality { Modality::COMPETITION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para contrução de prédio' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 2' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  price_registration { true }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_TOTAL_PRICE_BY_ITEM }
  disqualify_by_documentation_problem { true }
  disqualify_by_maximum_value { true }
  consider_law_of_proposals { false }
  execution_type { ExecutionType::INTEGRAL }
end

LicitationProcess.blueprint(:processo_licitatorio_concorrencia) do
  process { 2 }
  protocol { '00099/2012' }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::CONCURRENCE }
  description { 'Licitação para compra de computadores' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 2' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  price_registration { true }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  disqualify_by_documentation_problem { true }
  disqualify_by_maximum_value { true }
  consider_law_of_proposals { false }
  execution_type { ExecutionType::INTEGRAL }
  judgment_form { JudgmentForm.make!(:global)}
end

LicitationProcess.blueprint(:processo_licitatorio_tomada_preco) do
  process { 1 }
  protocol { '00099/2012' }
  object_type { AdministrativeProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES }
  modality { Modality::TAKEN_PRICE }
  description { 'Licitação para contrução de prédio' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 2' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  price_registration { true }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  disqualify_by_documentation_problem { true }
  disqualify_by_maximum_value { true }
  consider_law_of_proposals { false }
  execution_type { ExecutionType::INTEGRAL }
  judgment_form { JudgmentForm.make!(:global)}
end

LicitationProcess.blueprint(:processo_licitatorio_leilao) do
  process { 1 }
  protocol { '00088/2012' }
  object_type { AdministrativeProcessObjectType::DISPOSALS_OF_ASSETS }
  modality { Modality::AUCTION }
  judgment_form { JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) }
  description { 'Licitação para compra de carteiras' }
  responsible { Employee.make!(:sobrinho) }
  item { 'Item 1' }
  administrative_process_budget_allocations { [AdministrativeProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  licitation_number { 1 }
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
  price_registration { true }
  type_of_calculation { LicitationProcessTypeOfCalculation::LOWEST_GLOBAL_PRICE }
  disqualify_by_documentation_problem { true }
  disqualify_by_maximum_value { true }
  consider_law_of_proposals { false }
  execution_type { ExecutionType::INTEGRAL }
end
