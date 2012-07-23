# encoding: utf-8
MovimentType.blueprint(:adicionar_dotacao) do
  name { 'Adicionar dotação' }
  operation { MovimentTypeOperation::ADD }
  character { MovimentTypeCharacter::BUDGET_ALLOCATION }
  source { Source::DEFAULT }
end

MovimentType.blueprint(:subtrair_dotacao) do
  name { 'Subtrair dotação' }
  operation { MovimentTypeOperation::SUBTRACT }
  character { MovimentTypeCharacter::BUDGET_ALLOCATION }
  source { Source::DEFAULT }
end

MovimentType.blueprint(:subtrair_do_excesso_arrecadado) do
  name { 'Subtrair do excesso arrecadado' }
  operation { MovimentTypeOperation::SUBTRACT }
  character { MovimentTypeCharacter::CAPABILITY }
  source { Source::DEFAULT }
end

MovimentType.blueprint(:adicionar_em_outros_casos) do
  name { 'Adicionar em outros casos' }
  operation { MovimentTypeOperation::ADD }
  character { MovimentTypeCharacter::CAPABILITY }
  source { Source::DEFAULT }
end
