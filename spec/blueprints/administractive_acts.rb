# encoding: utf-8
AdministractiveAct.blueprint(:sopa) do
  act_number { "1234" }
  administractive_act_type { AdministractiveActType.make!(:lei) }
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

AdministractiveAct.blueprint(:emenda) do
  act_number { "4567" }
  administractive_act_type { AdministractiveActType.make!(:emenda) }
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
