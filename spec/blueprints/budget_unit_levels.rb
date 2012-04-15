# encoding: utf-8
BudgetUnitLevel.blueprint(:orgao) do
  description { 'Orgão' }
  level { 1 }
  digits { 2 }
  separator { BudgetUnitSeparator::POINT }
end

BudgetUnitLevel.blueprint(:unidade) do
  description { 'Unidade' }
  level { 2 }
  digits { 2 }
  separator { BudgetUnitSeparator::POINT }
end
