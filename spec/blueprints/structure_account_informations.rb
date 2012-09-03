StructureAccountInformation.blueprint(:fonte_de_recursos) do
  name { "Fonte de Recursos" }
  tce_code { 1 }
  capability_source { CapabilitySource.make!(:imposto) }
end
