# encoding: utf-8
BudgetStructureLevel.blueprint(:orgao) do
  description { 'Orgão' }
  level { 1 }
  digits { 2 }
  separator { BudgetStructureSeparator::POINT }
end

BudgetStructureLevel.blueprint(:unidade) do
  description { 'Unidade' }
  level { 2 }
  digits { 2 }
  separator { BudgetStructureSeparator::POINT }
end
