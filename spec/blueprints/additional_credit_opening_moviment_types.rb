AdditionalCreditOpeningMovimentType.blueprint(:adicionar_dotacao) do
  moviment_type { MovimentType.make!(:adicionar_dotacao) }
  budget_allocation { BudgetAllocation.make!(:alocacao) }
  value { '10,00' }
end

AdditionalCreditOpeningMovimentType.blueprint(:subtrair_do_excesso_arrecadado) do
  moviment_type { MovimentType.make!(:subtrair_do_excesso_arrecadado) }
  capability { Capability.make!(:reforma) }
  value { '10,00' }
end
