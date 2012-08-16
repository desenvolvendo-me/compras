# encoding: utf-8
BudgetStructureResponsible.blueprint(:sobrinho) do
  responsible { Employee.make!(:sobrinho) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  start_date { Date.new(2012, 2, 1) }
end

BudgetStructureResponsible.blueprint(:sobrinho_inativo) do
  responsible { Employee.make!(:sobrinho) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  start_date { Date.new(2012, 2, 1) }
  end_date { Date.new(2012, 4, 1) }
end

BudgetStructureResponsible.blueprint(:wenderson) do
  responsible { Employee.make!(:wenderson) }
  regulatory_act { RegulatoryAct.make!(:sopa) }
  start_date { Date.new(2012, 4, 1) }
end
