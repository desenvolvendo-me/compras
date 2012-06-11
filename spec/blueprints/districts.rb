District.blueprint(:sul) do
  name { "Sul" }
  city { City.make!(:belo_horizonte) }
end

District.blueprint(:norte) do
  name { "Norte" }
  city { City.make!(:belo_horizonte) }
end

District.blueprint(:centro) do
  name { "Centro" }
  city { City.make!(:belo_horizonte) }
end

District.blueprint(:leste) do
  name { "Leste" }
  city { City.make!(:porto_alegre) }
end

District.blueprint(:oeste) do
  name { "Oeste" }
  city { City.make!(:porto_alegre) }
end
