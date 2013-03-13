District.blueprint(:sul) do
  name { "Sul" }
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