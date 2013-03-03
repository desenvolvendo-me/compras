# encoding: utf-8
State.blueprint(:mg) do
  acronym { 'MG' }
  name    { 'Minas Gerais' }
  country { ::FactoryGirl::Preload.factories['Country'][:brazil] }
end

State.blueprint(:rs) do
  acronym { 'RS' }
  name    { 'Rio Grande do Sul' }
  country { ::FactoryGirl::Preload.factories['Country'][:brazil] }
end

State.blueprint(:pr) do
  acronym { 'PR' }
  name    { 'Paraná' }
  country { ::FactoryGirl::Preload.factories['Country'][:brazil] }
end
