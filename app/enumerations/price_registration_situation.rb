class PriceRegistrationSituation < EnumerateIt::Base
  associate_values :active, :canceled, :extended
end
