District.blueprint(:sul) do
  name { "Sul" }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
end

District.blueprint(:centro) do
  name { "Centro" }
  city { ::FactoryGirl::Preload.factories['City'][:belo_horizonte] }
end

District.blueprint(:leste) do
  name { "Leste" }
  city { ::FactoryGirl::Preload.factories['City'][:porto_alegre] }
end