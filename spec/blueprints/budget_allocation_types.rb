# encoding: utf-8
BudgetAllocationType.blueprint(:administrativa) do
  description { "Dotação Administrativa" }
  status { Status::ACTIVE }
end

BudgetAllocationType.blueprint(:presidencial) do
  description { "Dotação Presidencial" }
  status { Status::ACTIVE }
end
