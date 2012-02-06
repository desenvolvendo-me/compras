# encoding: utf-8
ServiceOrContractType.blueprint(:trainees) do
  tce_code { 123 }
  description { 'Contratação de estagiários' }
  service_goal { 'trainees' }
end

ServiceOrContractType.blueprint(:reparos) do
  tce_code { 123 }
  description { 'Reparos' }
  service_goal { 'trainees' }
end
