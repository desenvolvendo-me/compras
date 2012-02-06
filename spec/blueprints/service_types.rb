# encoding: utf-8
ServiceType.blueprint(:trainees) do
  tce_code { 123 }
  description { 'Contratação de estagiários' }
  service_goal { 'trainees' }
end

ServiceType.blueprint(:reparos) do
  tce_code { 123 }
  description { 'Reparos' }
  service_goal { 'trainees' }
end
