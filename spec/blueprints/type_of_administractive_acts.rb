TypeOfAdministractiveAct.blueprint(:lei) do
  description { 'Lei' }
  classification_of_types_of_administractive_act { ClassificationOfTypesOfAdministractiveAct.make!(:primeiro_tipo) }
end

TypeOfAdministractiveAct.blueprint(:emenda) do
  description { 'Emenda constitucional' }
  classification_of_types_of_administractive_act { ClassificationOfTypesOfAdministractiveAct.make!(:primeiro_tipo) }
end
