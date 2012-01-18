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
