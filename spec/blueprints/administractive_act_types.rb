AdministractiveActType.blueprint(:lei) do
  description { 'Lei' }
  administractive_act_type_classification { AdministractiveActTypeClassification.make!(:primeiro_tipo) }
end

AdministractiveActType.blueprint(:emenda) do
  description { 'Emenda constitucional' }
  administractive_act_type_classification { AdministractiveActTypeClassification.make!(:primeiro_tipo) }
end
