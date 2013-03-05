# encoding: utf-8
ContractType.blueprint(:trainees) do
  tce_code { 123 }
  description { 'Contratação de estagiários' }
  service_goal { 'trainees' }
end

ContractType.blueprint(:reparos) do
  tce_code { 123 }
  description { 'Reparos' }
  service_goal { 'trainees' }
end

ContractType.blueprint(:founded) do
  tce_code { 123 }
  description { 'Contrato de dívida' }
  service_goal { ServiceGoal::FOUNDED }
end

ContractType.blueprint(:management) do
  tce_code { 123 }
  description { 'Contrato de gerencia' }
  service_goal { ServiceGoal::CONTRACT_MANAGEMENT }
end
