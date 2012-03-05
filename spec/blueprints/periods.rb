Period.blueprint(:um_ano) do
  unit { PeriodUnit::YEAR }
  amount { 1 }
end

Period.blueprint(:tres_meses) do
  unit { PeriodUnit::MONTH }
  amount { 3 }
end
