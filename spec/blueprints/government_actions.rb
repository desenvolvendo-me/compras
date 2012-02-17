# encoding: utf-8
GovernmentAction.blueprint(:governamental) do
  year { 2012 }
  description { "Ação Governamental" }
  status { "active" }
  entity { Entity.make!(:detran) }
end

GovernmentAction.blueprint(:nacional) do
  year { 2012 }
  description { "Ação Nacional" }
  status { "active" }
  entity { Entity.make!(:secretaria_de_educacao) }
end
