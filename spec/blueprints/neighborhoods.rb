# encoding: utf-8
Neighborhood.blueprint(:centro) do
  name  { 'Centro' }
  city { City.make!(:belo_horizonte) }
end

Neighborhood.blueprint(:portugal) do
  name  { 'Portugal' }
  city { City.make!(:porto_alegre) }
  district { District.make!(:leste) }
end

Neighborhood.blueprint(:sao_francisco) do
  name  { 'São Francisco' }
  city { City.make!(:curitiba) }
end

Neighborhood.blueprint(:sao_francisco_bh) do
  name  { 'São Francisco' }
  city { City.make!(:belo_horizonte) }
end
