# encoding: utf-8
DeliveryLocation.blueprint(:education) do
  description { "Secretaria da Educação" }
  address { Address.make(:education) }
end

DeliveryLocation.blueprint(:health) do
  description { "Secretaria da Saúde" }
  address { Address.make(:general) }
end
