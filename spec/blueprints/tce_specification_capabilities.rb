# encoding: utf-8
TceSpecificationCapability.blueprint(:ampliacao) do
  description { "Ampliação do Posto de Saúde" }
  capability_source { CapabilitySource.make!(:imposto) }
  application_code { ApplicationCode.make!(:geral) }
end