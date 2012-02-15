TypeOfAdministractiveAct.blueprint(:lei) do
  description { 'Lei' }
  administractive_act_type_classification { AdministractiveActTypeClassification.make!(:primeiro_tipo) }
end

TypeOfAdministractiveAct.blueprint(:emenda) do
  description { 'Emenda constitucional' }
  administractive_act_type_classification { AdministractiveActTypeClassification.make!(:primeiro_tipo) }
end
