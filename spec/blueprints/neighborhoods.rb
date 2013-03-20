# encoding: utf-8
Neighborhood.blueprint(:centro) do
  name  { 'Centro' }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
end

Neighborhood.blueprint(:portugal) do
  name  { 'Portugal' }
  city { ::FactoryGirl::Preload.factories['City'][:porto_alegre] }
  district { ::FactoryGirl::Preload.factories['District'][:leste] }
end

Neighborhood.blueprint(:sao_francisco) do
  name  { 'São Francisco' }
  city { ::FactoryGirl::Preload.factories['City'][:curitiba] }
end

Neighborhood.blueprint(:sao_francisco_bh) do
  name  { 'São Francisco' }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
end
