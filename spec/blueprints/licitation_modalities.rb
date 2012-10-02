# encoding: utf-8
LicitationModality.blueprint(:publica) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Pública" }
  initial_value { "500.00" }
  final_value { "700.00" }
  object_type { "purchase_and_services" }
end

LicitationModality.blueprint(:privada) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Privada" }
  initial_value { "500.00" }
  final_value { "800.00" }
  object_type { "purchase_and_services" }
end
