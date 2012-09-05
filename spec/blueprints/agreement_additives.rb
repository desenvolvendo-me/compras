# encoding: utf-8
AgreementAdditive.blueprint(:termo_de_aditamento) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  kind { AgreementAdditiveKind::OTHERS }
  value { 100.00 }
  description { 'Termo de aditamento' }
  number { 1 }
end
