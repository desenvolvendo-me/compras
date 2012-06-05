# encoding: utf-8
BudgetStructureConfiguration.blueprint(:detran_sopa) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { 'Configuração do Detran' }
  budget_structure_levels { [BudgetStructureLevel.make!(:orgao), BudgetStructureLevel.make!(:unidade)] }
end
