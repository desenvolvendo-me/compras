# encoding: utf-8
LicitationModality.blueprint(:publica) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Pública" }
  initial_value { "500.00" }
  final_value { "700.00" }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality_type { AdministrativeProcessModality::COMPETITION_FOR_PURCHASES_AND_SERVICES }
end

LicitationModality.blueprint(:privada) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Privada" }
  initial_value { "500.00" }
  final_value { "800.00" }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality_type { AdministrativeProcessModality::COMPETITION_FOR_PURCHASES_AND_SERVICES }
end

LicitationModality.blueprint(:pregao_presencial) do
  regulatory_act { RegulatoryAct.make!(:sopa) }
  description { "Pregão presencial" }
  initial_value { "600.00" }
  final_value { "900.00" }
  object_type { AdministrativeProcessObjectType::PURCHASE_AND_SERVICES }
  modality_type { AdministrativeProcessModality::PRESENCE_TRADING }
end
