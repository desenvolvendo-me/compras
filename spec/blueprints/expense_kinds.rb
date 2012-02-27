ExpenseKind.blueprint(:pagamentos) do
  description { "Pagamentos" }
  status { Status::ACTIVE }
end

ExpenseKind.blueprint(:alojamento) do
  description { "Alojamento" }
  status { Status::ACTIVE }
end
