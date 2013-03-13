Address.blueprint(:apto) do
  neighborhood { Neighborhood.make!(:sao_francisco) }
  street { Street.make!(:girassol_curitiba) }
  land_subdivision { LandSubdivision.make!(:solar_da_serra) }
  condominium { Condominium.make!(:parque_das_flores) }
  complement { "Apto 34" }
  zip_code { "33400-500" }
  number { 9874 }
  addressable { nil }
end

Address.blueprint(:general) do
  neighborhood { Neighborhood.make!(:sao_francisco) }
  street { Street.make!(:girassol_curitiba) }
  land_subdivision { LandSubdivision.make!(:solar_da_serra) }
  condominium { Condominium.make!(:parque_das_flores) }
  complement { "Apto 34" }
  zip_code { "33400-500" }
  number { 0666 }
  addressable { nil }
end

Address.blueprint(:education) do
  neighborhood { Neighborhood.make!(:portugal) }
  street { Street.make!(:amazonas) }
  land_subdivision { LandSubdivision.make!(:horizonte_a_vista) }
  condominium { Condominium.make!(:tambuata) }
  complement { "Logo ali" }
  zip_code { "33600-500" }
  number { 3524 }
  addressable { nil }
end
