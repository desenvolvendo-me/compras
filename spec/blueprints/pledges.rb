Pledge.blueprint(:empenho) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  management_unit { ManagementUnit.make!(:unidade_central) }
  emission_date { I18n.l(Date.current) }
  commitment_type { CommitmentType.make!(:primeiro_empenho) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { "9.99" }
  pledge_category { PledgeCategory.make!(:geral) }
end
