# encoding: utf-8
BudgetStructureConfiguration.blueprint(:detran_sopa) do
  entity { Entity.make!(:detran) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { 'Configuração do Detran' }
  budget_structure_levels { [BudgetStructureLevel.make!(:orgao), BudgetStructureLevel.make!(:unidade)] }
end

BudgetStructureConfiguration.blueprint(:secretaria_de_educacao) do
  entity { Entity.make!(:secretaria_de_educacao) }
  regulatory_act { RegulatoryAct.make!(:emenda) }
  description { 'Configuração da secretaria de educação' }
  budget_structure_levels { [BudgetStructureLevel.make!(:level_1), BudgetStructureLevel.make!(:level_2)] }
end
