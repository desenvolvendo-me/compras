CheckingAccountStructureInformation.blueprint(:fonte_de_recursos) do
  name { "Fonte de Recursos" }
  tce_code { 1 }
  capability_source { CapabilitySource.make!(:imposto) }
end

CheckingAccountStructureInformation.blueprint(:outras_fontes) do
  name { "Outras Fontes" }
  tce_code { 3 }
  capability_source { CapabilitySource.make!(:imposto) }
end
