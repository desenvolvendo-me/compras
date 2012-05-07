# encoding: utf-8
Subpledge.blueprint(:empenho_2012) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  pledge { Pledge.make!(:empenho) }
  number { 1 }
  provider { Provider.make!(:wenderson_sa) }
  date { Date.current }
  value { 1 }
  process_number { "1239/2012" }
  description { "Aquisição de material" }
end
