City.blueprint(:belo_horizonte) do
  name  { 'Belo Horizonte' }
  state { State.make!(:mg) }
end

City.blueprint(:porto_alegre) do
  name  { 'Porto Alegre' }
  state { State.make!(:rs) }
end

City.blueprint(:curitiba) do
  name  { 'Curitiba' }
  state { State.make!(:pr) }
end
