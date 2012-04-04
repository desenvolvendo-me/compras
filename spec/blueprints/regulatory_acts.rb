# encoding: utf-8
RegulatoryAct.blueprint(:sopa) do
  act_number { "1234" }
  regulatory_act_type { RegulatoryActType.make!(:lei) }
  legal_text_nature { LegalTextNature.make!(:civica) }
  creation_date { "01/01/2012" }
  publication_date { "02/01/2012" }
  vigor_date { "03/01/2012" }
  end_date { "09/01/2012" }
  content { "conteudo" }
  budget_law_percent { "5.00" }
  revenue_antecipation_percent { "3.00" }
  authorized_debt_value { "7000.00" }
  dissemination_sources { [DisseminationSource.make!(:jornal_bairro)] }
end

RegulatoryAct.blueprint(:emenda) do
  act_number { "4567" }
  regulatory_act_type { RegulatoryActType.make!(:emenda) }
  legal_text_nature { LegalTextNature.make!(:civica) }
  creation_date { "01/01/2012" }
  publication_date { "02/01/2012" }
  vigor_date { "03/01/2012" }
  end_date { "09/01/2012" }
  content { "conteúdo" }
  budget_law_percent { "1.00" }
  revenue_antecipation_percent { "5.00" }
  authorized_debt_value { "4000.00" }
end

RegulatoryAct.blueprint(:medida_provisoria) do
  act_number { "8901" }
  regulatory_act_type { RegulatoryActType.make!(:emenda) }
  legal_text_nature { LegalTextNature.make!(:civica) }
  creation_date { "01/01/2013" }
  publication_date { "02/01/2013" }
  vigor_date { "03/01/2013" }
  end_date { "09/01/2013" }
  content { "conteúdo" }
  budget_law_percent { "1.00" }
  revenue_antecipation_percent { "5.00" }
  authorized_debt_value { "4000.00" }
end