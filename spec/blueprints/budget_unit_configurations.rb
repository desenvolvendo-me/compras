# encoding: utf-8
BudgetUnitConfiguration.blueprint(:detran_sopa) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { 'Configuração do Detran' }
  budget_unit_levels { [BudgetUnitLevel.make!(:orgao), BudgetUnitLevel.make!(:unidade)] }
end
