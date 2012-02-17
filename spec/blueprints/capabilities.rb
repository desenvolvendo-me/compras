# encoding: utf-8
Capability.blueprint(:reforma) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  description { 'Reforma e Ampliação' }
  goal { 'Otimizar o atendimento a todos' }
  kind { CapabilityKind::ORDINARY }
  status { CapabilityStatus::ACTIVE }
end

Capability.blueprint(:construcao) do
  entity { Entity.make!(:detran) }
  year { 2012 }
  description { 'Construção' }
  goal { 'Duplicar o atendimento a todos' }
  kind { CapabilityKind::ORDINARY }
  status { CapabilityStatus::ACTIVE }
end
