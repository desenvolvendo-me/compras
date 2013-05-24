# encoding: utf-8
Capability.blueprint(:reforma) do
  description { 'Reforma e Ampliação' }
  goal { 'Otimizar o atendimento a todos' }
  kind { CapabilityKind::ORDINARY }
  status { Status::ACTIVE }
end

Capability.blueprint(:construcao) do
  description { 'Construção' }
  goal { 'Duplicar o atendimento a todos' }
  kind { CapabilityKind::ORDINARY }
  status { Status::ACTIVE }
end
