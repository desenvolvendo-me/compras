Property.blueprint(:propriedade_1) do
  property_registration { "123" }
  owners { [Owner.make!(:wenderson)] }
end

Property.blueprint(:propriedade_2) do
  property_registration { "456" }
end
