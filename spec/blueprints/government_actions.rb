# encoding: utf-8
GovernmentAction.blueprint(:governamental) do
  year { 2012 }
  description { "Ação Governamental" }
  status { Status::ACTIVE }
  entity { Entity.make!(:detran) }
end

GovernmentAction.blueprint(:nacional) do
  year { 2012 }
  description { "Ação Nacional" }
  status { Status::ACTIVE }
  entity { Entity.make!(:secretaria_de_educacao) }
end
