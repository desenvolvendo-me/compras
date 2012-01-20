# encoding: utf-8
DeliveryLocation.blueprint(:education) do
  name { "Secretaria da Educação" }
  address { Address.make(:education) }
end

DeliveryLocation.blueprint(:health) do
  name { "Secretaria da Saúde" }
  address { Address.make(:general) }
end
