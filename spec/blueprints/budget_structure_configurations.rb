# encoding: utf-8
BudgetStructureConfiguration.blueprint(:detran_sopa) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { 'Configuração do Detran' }
  budget_structure_levels { [BudgetStructureLevel.make!(:orgao), BudgetStructureLevel.make!(:unidade)] }
  year { Date.current.year }
end
