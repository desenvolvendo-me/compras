# encoding: utf-8

Street.blueprint(:amazonas) do
  name        { "Amazonas" }
  street_type { StreetType.make!(:avenida) }
  tax_zone    { "2" }
  city { ::FactoryGirl::Preload.factories['City'][:porto_alegre] }
  neighborhoods { [::FactoryGirl::Preload.factories['Neighborhood'][:portugal_porto_alegre]] }
end

Street.blueprint(:girassol) do
  name        { "Girassol" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
  neighborhoods { [::FactoryGirl::Preload.factories['Neighborhood'][:centro_bh], ::FactoryGirl::Preload.factories['Neighborhood'][:sao_francisco_bh]] }
end

Street.blueprint(:girassol_curitiba) do
  name        { "Girassol" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { ::FactoryGirl::Preload.factories['City'][:curitiba] }
  neighborhoods { [::FactoryGirl::Preload.factories['Neighborhood'][:sao_francisco_curitiba]] }
end

Street.blueprint(:bento_goncalves) do
  name        { "Bento Gonçalves" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { ::FactoryGirl::Preload.factories['City'][:porto_alegre] }
  neighborhoods { [::FactoryGirl::Preload.factories['Neighborhood'][:portugal_porto_alegre]] }
end

Street.blueprint(:cristiano_machado) do
  name        { "Cristiano Machado" }
  street_type { StreetType.make!(:avenida) }
  tax_zone    { "2" }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
  neighborhoods { [::FactoryGirl::Preload.factories['Neighborhood'][:centro_bh]] }
end
