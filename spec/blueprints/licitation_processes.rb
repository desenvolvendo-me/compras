# encoding: utf-8
LicitationProcess.blueprint(:processo_licitatorio) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::CONCURRENCE }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  price_registration { true }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_computador) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 2 }
  protocol { '00089/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::CONCURRENCE }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  bidders { [Bidder.make!(:licitante)] }
  execution_type { ExecutionType::INTEGRAL }
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_fornecedores) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  bidders { [Bidder.make!(:licitante), Bidder.make!(:licitante_sobrinho)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_publicacao_cancelada) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao_de_cancelamento)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_canetas) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 2 }
  protocol { '00089/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  items { [PurchaseProcessItem.make!(:item),
           PurchaseProcessItem.make!(:item_arame)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  bidders { [Bidder.make!(:licitante)] }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_por_itens) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  items { [PurchaseProcessItem.make!(:item),
           PurchaseProcessItem.make!(:item_arame)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_por_lote) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_lote_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  items { [PurchaseProcessItem.make!(:item),
           PurchaseProcessItem.make!(:item_arame)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:valor_maximo_ultrapassado) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_lote_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  items { [PurchaseProcessItem.make!(:item),
           PurchaseProcessItem.make!(:item_arame)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_3),
             Bidder.make!(:licitante_com_proposta_7)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_global) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_global_empatou) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_5),
             Bidder.make!(:licitante_com_proposta_6)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_global_sem_documentos) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_6, :documents => []),
             Bidder.make!(:licitante_com_proposta_4, :documents => [])] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_global_small_company) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_3),
             Bidder.make!(:licitante_com_proposta_4)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_global_small_company_2) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_8),
             Bidder.make!(:licitante_com_proposta_9)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_nao_atualizavel) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao_nao_atualizavel)] }
  licitation_process_lots { [LicitationProcessLot.make(:lote_antivirus, :licitation_process => object)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_canetas_sem_lote) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 2 }
  protocol { '00089/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_2_itens)] }
  items { [PurchaseProcessItem.make!(:item),
           PurchaseProcessItem.make!(:item_arame)] }
  year { 2013 }
  process_date { Date.new(2013, 3, 20) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  bidders { [Bidder.make!(:licitante)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:apuracao_melhor_tecnica_e_preco) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::INVITATION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  bidders { [Bidder.make!(:licitante_com_proposta_1),
             Bidder.make!(:licitante_com_proposta_2)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:pregao_presencial) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::TRADING }
  judgment_form { JudgmentForm.make!(:por_item_com_menor_preco) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  summarized_object { "Descrição resumida do objeto" }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "00:00" }
  proposal_envelope_opening_date { I18n.l(Date.current) }
  proposal_envelope_opening_time { "00:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao,
                                                                        :licitation_process => object)] }
  bidders { [Bidder.make!(:licitante_sobrinho), Bidder.make!(:licitante), Bidder.make!(:me_pregao)] }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_concurso) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00099/2012' }
  object_type { PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES }
  modality { Modality::COMPETITION }
  judgment_form { JudgmentForm.make!(:por_item_com_melhor_tecnica) }
  description { 'Licitação para contrução de prédio' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  price_registration { true }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_concorrencia) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 2 }
  protocol { '00099/2012' }
  object_type { PurchaseProcessObjectType::PURCHASE_AND_SERVICES }
  modality { Modality::CONCURRENCE }
  description { 'Licitação para compra de computadores' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  price_registration { true }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco)}
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_tomada_preco) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00099/2012' }
  object_type { PurchaseProcessObjectType::CONSTRUCTION_AND_ENGINEERING_SERVICES }
  modality { Modality::TAKEN_PRICE }
  description { 'Licitação para contrução de prédio' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  price_registration { true }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  judgment_form { JudgmentForm.make!(:global_com_menor_preco)}
  notice_availability_date { I18n.l(Date.tomorrow) }
end

LicitationProcess.blueprint(:processo_licitatorio_leilao) do
  type_of_purchase { PurchaseProcessTypeOfPurchase::LICITATION }
  process { 1 }
  protocol { '00088/2012' }
  object_type { PurchaseProcessObjectType::DISPOSALS_OF_ASSETS }
  modality { Modality::AUCTION }
  judgment_form { JudgmentForm.make!(:global_com_melhor_lance_ou_oferta) }
  description { 'Licitação para compra de carteiras' }
  purchase_process_budget_allocations { [PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens)] }
  items { [PurchaseProcessItem.make!(:item)] }
  year { 2012 }
  process_date { Date.new(2012, 3, 19) }
  expiration { 10 }
  expiration_unit { PeriodUnit::DAY }
  readjustment_index { Indexer.make!(:xpto) }
  envelope_delivery_date { I18n.l(Date.current) }
  envelope_delivery_time { "14:00" }
  proposal_envelope_opening_date { I18n.l(Date.tomorrow) }
  proposal_envelope_opening_time { "14:00" }
  period { 1 }
  period_unit { PeriodUnit::YEAR }
  payment_method { PaymentMethod.make!(:dinheiro) }
  caution_value { 9.99 }
  document_types { [DocumentType.make!(:fiscal)] }
  licitation_process_publications { [LicitationProcessPublication.make!(:publicacao)] }
  price_registration { true }
  execution_type { ExecutionType::INTEGRAL }
  contract_guarantees { ContractGuarantees::BANK }
  notice_availability_date { I18n.l(Date.tomorrow) }
end
