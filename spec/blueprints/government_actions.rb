# encoding: utf-8
GovernmentAction.blueprint(:governamental) do
  year { 2012 }
  description { "Ação Governamental" }
  status { "active" }
  entity { Entity.make!(:detran) }
end
