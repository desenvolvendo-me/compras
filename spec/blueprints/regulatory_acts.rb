RegulatoryAct.blueprint(:sopa) do
  act_number { "1234" }
  regulatory_act_type { RegulatoryActType::LDO }
  creation_date { Date.new(2012, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2012, 1, 2) }
  vigor_date { Date.new(2012, 1, 3) }
  end_date { Date.new(2012, 1, 9) }
  content { "conteudo" }
  dissemination_sources { [DisseminationSource.make!(:jornal_bairro)] }
  classification { RegulatoryActClassification::LAW }
  parent { nil }
  budget_change_decree_type { nil }
  origin { nil }
  authorized_value { 1.0 }
  additional_percent { 1.0 }
  budget_change_law_type { BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW }
end

RegulatoryAct.blueprint(:medida_provisoria) do
  act_number { "8901" }
  regulatory_act_type { RegulatoryActType::LDO }
  creation_date { Date.new(2012, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2012, 1, 2) }
  vigor_date { Date.new(2012, 1, 3) }
  end_date { Date.new(2012, 1, 9) }
  content { "Medida provisória" }
  dissemination_sources { [DisseminationSource.make!(:jornal_bairro)] }
  classification { RegulatoryActClassification::LAW }
  parent { nil }
  budget_change_decree_type { nil }
  origin { nil }
  budget_change_law_type { nil }
end

RegulatoryAct.blueprint(:emenda) do
  act_number { "4567" }
  regulatory_act_type { RegulatoryActType::LDO }
  creation_date { Date.new(2012, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2012, 1, 2) }
  vigor_date { Date.new(2012, 1, 3) }
  end_date { Date.new(2012, 1, 9) }
  content { "conteúdo" }
  classification { RegulatoryActClassification::LAW }
  budget_change_decree_type { nil }
  origin { nil }
  authorized_value { 1.0 }
  additional_percent { 1.0 }
  budget_change_law_type { BudgetChangeLawType::SPECIAL_CREDIT_AUTHORIZATION_LAW }
end
