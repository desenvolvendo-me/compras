# encoding: utf-8
OrganogramResponsible.blueprint(:sobrinho) do
  responsible { Employee.make!(:sobrinho) }
  administractive_act { AdministractiveAct.make!(:sopa) }
  start_date { Date.new(2012, 2, 1) }
  end_date { Date.new(2012, 2, 10) }
  status { Status::ACTIVE }
end
