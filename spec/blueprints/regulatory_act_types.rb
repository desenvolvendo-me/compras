RegulatoryActType.blueprint(:lei) do
  description { 'Lei' }
  regulatory_act_type_classification { RegulatoryActTypeClassification.make!(:primeiro_tipo) }
end

RegulatoryActType.blueprint(:emenda) do
  description { 'Emenda constitucional' }
  regulatory_act_type_classification { RegulatoryActTypeClassification.make!(:primeiro_tipo) }
end
