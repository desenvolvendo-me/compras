# encoding: utf-8
AccountPlanLevel.blueprint(:orgao) do
  description { 'Orgão' }
  level { 1 }
  digits { 1 }
  separator { AccountPlanSeparator::POINT }
end

AccountPlanLevel.blueprint(:unidade) do
  description { 'Unidade' }
  level { 2 }
  digits { 2 }
  separator { AccountPlanSeparator::POINT }
end

AccountPlanLevel.blueprint(:primeiro_nivel_com_ponto) do
  description { 'Nível 1' }
  level { 1 }
  digits { 2 }
  separator { BudgetStructureSeparator::POINT }
end

AccountPlanLevel.blueprint(:segundo_nivel_com_ponto) do
  description { 'Nível 2' }
  level { 2 }
  digits { 2 }
  separator { BudgetStructureSeparator::POINT }
end
