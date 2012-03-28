# encoding: utf-8
OrganogramConfiguration.blueprint(:detran_sopa) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { 'Configuração do Detran' }
  organogram_levels { [OrganogramLevel.make!(:orgao), OrganogramLevel.make!(:unidade)] }
end
