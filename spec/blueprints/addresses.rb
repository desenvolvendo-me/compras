Address.blueprint(:apto) do
  neighborhood { ::FactoryGirl::Preload.factories['Neighborhood'][:sao_francisco_curitiba] }
  street { Street.make!(:girassol_curitiba) }
  land_subdivision { ::FactoryGirl::Preload.factories['LandSubdivision'][:solar_da_serra] }
  condominium { ::FactoryGirl::Preload.factories['Condominium'][:parque_das_flores] }
  complement { "Apto 34" }
  zip_code { "33400-500" }
  number { 9874 }
  addressable { nil }
end

Address.blueprint(:general) do
  neighborhood { ::FactoryGirl::Preload.factories['Neighborhood'][:sao_francisco_curitiba] }
  street { Street.make!(:girassol_curitiba) }
  land_subdivision { ::FactoryGirl::Preload.factories['LandSubdivision'][:solar_da_serra] }
  condominium { ::FactoryGirl::Preload.factories['Condominium'][:parque_das_flores] }
  complement { "Apto 34" }
  zip_code { "33400-500" }
  number { 0666 }
  addressable { nil }
end

Address.blueprint(:education) do
  neighborhood { ::FactoryGirl::Preload.factories['Neighborhood'][:portugal_porto_alegre] }
  street { Street.make!(:amazonas) }
  land_subdivision { ::FactoryGirl::Preload.factories['LandSubdivision'][:horizonte_a_vista] }
  condominium { ::FactoryGirl::Preload.factories['Condominium'][:tambuata] }
  complement { "Logo ali" }
  zip_code { "33600-500" }
  number { 3524 }
  addressable { nil }
end

Address.blueprint(:apto_bh) do
  neighborhood { ::FactoryGirl::Preload.factories['Neighborhood'][:centro_bh] }
  street { Street.make!(:cristiano_machado) }
  land_subdivision { ::FactoryGirl::Preload.factories['LandSubdivision'][:solar_da_serra] }
  condominium { ::FactoryGirl::Preload.factories['Condominium'][:parque_das_flores] }
  complement { "Apto 34" }
  zip_code { "33400-500" }
  number { 9874 }
  addressable { nil }
end
