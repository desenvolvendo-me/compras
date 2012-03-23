# encoding: utf-8
MovimentType.blueprint(:adicionar_dotacao) do
  name { 'Adicionar dotação' }
  operation { MovimentTypeOperation::SUM }
  character { MovimentTypeCharacter::BUDGET_ALLOCATION }
end

MovimentType.blueprint(:subtrair_do_excesso_arrecadado) do
  name { 'Subtrair do excesso arrecadado' }
  operation { MovimentTypeOperation::SUBTRATION }
  character { MovimentTypeCharacter::CAPABILITY }
end
