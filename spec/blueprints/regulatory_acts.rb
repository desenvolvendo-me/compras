# encoding: utf-8
RegulatoryAct.blueprint(:sopa) do
  act_number { "1234" }
  regulatory_act_type { RegulatoryActType.make!(:lei) }
  creation_date { Date.new(2012, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2012, 1, 2) }
  vigor_date { Date.new(2012, 1, 3) }
  end_date { Date.new(2012, 1, 9) }
  content { "conteudo" }
  budget_law_percent { "5.00" }
  revenue_antecipation_percent { "3.00" }
  authorized_debt_value { "7000.00" }
  dissemination_sources { [DisseminationSource.make!(:jornal_bairro)] }
  classification { RegulatoryActClassification::LAW }
end

RegulatoryAct.blueprint(:medida_provisoria) do
  act_number { "8901" }
  regulatory_act_type { RegulatoryActType.make!(:emenda) }
  creation_date { Date.new(2013, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2013, 1, 2) }
  vigor_date { Date.new(2013, 1, 3) }
  end_date { Date.new(2013, 1, 9) }
  content { "conteúdo" }
  budget_law_percent { "1.00" }
  revenue_antecipation_percent { "5.00" }
  authorized_debt_value { "4000.00" }
  classification { RegulatoryActClassification::LAW }
end

RegulatoryAct.blueprint(:emenda) do
  act_number { "4567" }
  regulatory_act_type { RegulatoryActType.make!(:emenda) }
  creation_date { Date.new(2012, 1, 1) }
  signature_date { Date.new(2012, 1, 1) }
  publication_date { Date.new(2012, 1, 2) }
  vigor_date { Date.new(2012, 1, 3) }
  end_date { Date.new(2012, 1, 9) }
  content { "conteúdo" }
  budget_law_percent { "1.00" }
  revenue_antecipation_percent { "5.00" }
  authorized_debt_value { "4000.00" }
  classification { RegulatoryActClassification::LAW }
end
