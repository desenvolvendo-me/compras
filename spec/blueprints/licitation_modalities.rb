# encoding: utf-8
LicitationModality.blueprint(:publica) do
  administractive_act { AdministractiveAct.make!(:sopa) }
  description { "Pública" }
  initial_value { "500.00" }
  final_value { "700.00" }
end
