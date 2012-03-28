# encoding: utf-8
MovimentType.blueprint(:adicionar_dotacao) do
  name { 'Adicionar dotação' }
  operation { MovimentTypeOperation::SUM }
  character { MovimentTypeCharacter::BUDGET_ALLOCATION }
end

MovimentType.blueprint(:subtrair_dotacao) do
  name { 'Subtrair dotação' }
  operation { MovimentTypeOperation::SUBTRATION }
  character { MovimentTypeCharacter::BUDGET_ALLOCATION }
end

MovimentType.blueprint(:subtrair_do_excesso_arrecadado) do
  name { 'Subtrair do excesso arrecadado' }
  operation { MovimentTypeOperation::SUBTRATION }
  character { MovimentTypeCharacter::CAPABILITY }
end

MovimentType.blueprint(:adicionar_em_outros_casos) do
  name { 'Adicionar em outros casos' }
  operation { MovimentTypeOperation::SUM }
  character { MovimentTypeCharacter::CAPABILITY }
end
