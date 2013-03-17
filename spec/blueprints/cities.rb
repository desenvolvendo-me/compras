City.blueprint(:belo_horizonte) do
  name  { 'Belo Horizonte' }
  state { ::FactoryGirl::Preload.factories['State'][:mg] }
end

City.blueprint(:porto_alegre) do
  name  { 'Porto Alegre' }
  state { ::FactoryGirl::Preload.factories['State'][:rs] }
end

City.blueprint(:curitiba) do
  name  { 'Curitiba' }
  state { ::FactoryGirl::Preload.factories['State'][:pr] }
end